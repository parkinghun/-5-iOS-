//
//  UserDBRepository.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
  func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
  func getUser(userId: String) async throws -> UserObject
  func updateUser(userId: String, key: String, value: Any) async throws
  func loadUser() -> AnyPublisher<[UserObject], DBError>
  func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
}

// Firebase Realtime Database로부터 데이터 저장하고, 가져오기
final class UserDBRepository: UserDBRepositoryType {
  
  // reference는 데이터베이스의 루트에 해당함.
  var db: DatabaseReference = Database.database().reference()
  
  /// 해당하는 유저 정보를 받아서 DB에 넣어줌
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
    // object -> data -> dic
    Just(object)
      .compactMap { try? JSONEncoder().encode($0) }  // object -> data
      .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }  // data -> dic
      .flatMap { value in   // DB Set 작업
        Future<Void, Error> { [weak self] promise in  // Users/userId/ ..
          self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
            if let error {
              promise(.failure(error))
            } else {
              promise(.success(()))
            }
          }
        }
      }
      .mapError { DBError.error($0) }  // 에러타입을 DBErroro로 변경
      .eraseToAnyPublisher()
  }
  
  func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
    // DB get - dic -> data (data Serialization) -> object
    // Any?인 이유 - snapshot?.value가 Any? 타입이기 때문
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.Users).child(userId).getData { error, snapshot in
        if let error {
          promise(.failure(DBError.error(error)))
        } else if snapshot?.value is NSNull {  // snapshot의 value가 NSNull인가?
          promise(.success(nil))
        } else {
          promise(.success(snapshot?.value))
        }
      }
    }.flatMap { value in  // value를 userObject로 변환
      if let value {
        // snapshot?.value 또한 딕셔너리 형태임 -> 우리가 원하는 UserObject로 변환하기 위해서
        // 딕셔너리를 데이터화 하고, 데이터를 json decoder를 통해 파싱함
        return Just(value)
          .tryMap { try JSONSerialization.data(withJSONObject: $0) }
          .decode(type: UserObject.self, decoder: JSONDecoder())
          .mapError { DBError.error($0) }
          .eraseToAnyPublisher()
      } else {
        // 유저에 대한 정보가 없을 때는 실패가 나는게 맞을 것 같음
        return Fail(error: .emptyValue).eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }
  
  // Swift Concurrency 이용
  func getUser(userId: String) async throws -> UserObject {
    guard let value = try await self.db.child(DBKey.Users).child(userId).getData().value else {
      throw DBError.emptyValue
    }
    
    let data = try JSONSerialization.data(withJSONObject: value)
    let userObject = try JSONDecoder().decode(UserObject.self, from: data)
    return userObject
  }
  
  func updateUser(userId: String, key: String, value: Any) async throws {
    try await self.db.child(DBKey.Users).child(userId).child(key).setValue(value)
  }
  
  /// [UserObject] 가져오기
  func loadUser() -> AnyPublisher<[UserObject], DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.Users).getData { error, snapshot in
        if let error {
          promise(.failure(DBError.error(error)))
        } else if snapshot?.value is NSNull {
          promise(.success(nil))
        } else {
          promise(.success(snapshot?.value))
        }
      }
    }.flatMap { value in  // Dic을 [UserObject]로 변환
      if let dic = value as? [String: [String: Any]] {  // 타입 체크
        return Just(dic)
          .tryMap { try JSONSerialization.data(withJSONObject: $0) }  // object를 데이터화
          .decode(type: [String: UserObject].self, decoder: JSONDecoder())
          .map { $0.values.map { $0 as UserObject} }  // 딕셔너리의 value 값만 뽑아옴, values가 UserObject인지 자동으로 추론화가 안되어 타입을 명시해줌
          .mapError { DBError.error($0) }  // serialization, decoding에서 나오는 에러를 DBError로 바꿔줌
          .eraseToAnyPublisher()
      } else if value == nil {
        // setFailureType - Never로 설정된 실패 타입을 특정 오류 타입으로 변환하는 역할
        // Combine 체인에서 실패 타입이 다른 Publisher들과 일치하도록 맞춰야 할 때 사용
        return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
      } else {
        return Fail(error: .invalidatedType).eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
    /*
     Users/
        user_id: [String, Any]  // 유저오브젝트를 딕셔너리화한 상태로 저장
        user_id: [String, Any]
        user_id: [String, Any]
     */
    // zip 사용 - steam으로 1스트림은 유저정보를 변환하지 않는 퍼블리셔, 2변환하는 퍼블리셔
    
    Publishers.Zip(users.publisher, users.publisher)
      .compactMap { origin, converted in  // 1. converted를 데이터화 함.
        if let converted = try? JSONEncoder().encode(converted) {
          return (origin, converted)
        } else {
          return nil
        }
      }
      .compactMap { origin, converted in  // 2. 데이터화된 아웃풋을 딕셔너리화 하기
        if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
          return (origin, converted)
        } else {
          return nil
        }
      }
      .flatMap { origin, converted in  // 3. DB 연동
        Future<Void, Error> { [weak self] promise in
          self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
            if let error {
              promise(.failure(error))
            } else {
              promise(.success(()))
            }
          }
        }
      }
      .last()  // 마지막 결과를 보낸 후, ui를 업데이트하면 되기 때문에 last 사용 - 공부하기
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
}
