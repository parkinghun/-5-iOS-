//
//  UserService.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation
import Combine

protocol UserServiceType {
  // 서비스레이어이기 때문에 DTO가 아닌 User 모델을 받음
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
  func getUser(userId: String) -> AnyPublisher<User, ServiceError>
  func getUser(userId: String) async throws -> User
  func updateDescription(userId: String, description: String) async throws
  func updateProfileURL(userId: String, urlString: String) async throws
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError>
}

final class UserService: UserServiceType {
  
  private var dbRepository: UserDBRepositoryType
  
  // UserDBRepositoryType를 주입받아서 해당 respository에 접근할 수 있도록 설계
  init(dbRepository: UserDBRepositoryType) {
    self.dbRepository = dbRepository
  }
  
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    // db가 성공했는지에 대한 여부만 보내줌 output이 AnyPublisher<Void, DBError>
    dbRepository.addUser(user.toObject())  // dbRepository 호출 (결과: AnyPublisher<Void, DBError>)
      .map { user }  // 성공 시, 방출된 Void를 User로 변환
      .mapError { .error($0) }   // 에러 발생 시 DBError를 ServiceError로 변환
      .eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
    dbRepository.addUserAfterContact(users: users.map { $0.toObject() })
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  // UserObject -> User
  func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
    dbRepository.getUser(userId: userId)
      .map { $0.toModel() }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func getUser(userId: String) async throws -> User {
    let userObject = try await dbRepository.getUser(userId: userId)
    return userObject.toModel()
  }
  
  func updateDescription(userId: String, description: String) async throws {
    try await dbRepository.updateUser(userId: userId, key: "description", value: description)
  }

  func updateProfileURL(userId: String, urlString: String) async throws {
    try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString)
  }
  
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError> {
    dbRepository.loadUser()  // [UserObject]
      .map { $0.map { $0.toModel() }
          .filter { $0.id != id }  // 받아온 데이터에서 본인의 데이터는 걸러냄
      }
      .mapError { ServiceError.error($0) }
      .eraseToAnyPublisher()
  }
  
}

final class StubUserService: UserServiceType {
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
    Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
  }
  
  func getUser(userId: String) async throws -> User {
    return .stub1
  }
  
  func updateDescription(userId: String, description: String) async throws {
    
  }
  
  func updateProfileURL(userId: String, urlString: String) async throws {
    
  }
  
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError> {
    Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
  }
}
