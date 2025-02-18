//
//  ChatRoomDBRepository.swift
//  LMessanger
//
//  Created by 박성훈 on 1/15/25.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
  func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>
  func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
  var db: DatabaseReference = Database.database().reference()
  
  // 채팅방이 존재하는지 확인하는 코드
  func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.ChatRooms).child(myUserId).child(otherUserId).getData { error, snapshot in
        if let error {
          promise(.failure(DBError.error(error)))
        } else if snapshot?.value is NSNull {
          promise(.success(nil))
        } else {
          promise(.success(snapshot?.value))
        }
      }
    }
    .flatMap { value in
      if let value {
        return Just(value)
          .tryMap { try JSONSerialization.data(withJSONObject: $0)}
          .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())
          .mapError { DBError.error($0) }
          .eraseToAnyPublisher()
      } else {
        return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }
  
  // 챗룸오브젝트를 스트림화해서 인코딩 / 딕셔너리화 / 챗룸/myUserId/OhterUserId 경로로 추가
  func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
    Just(object)
      .compactMap { try? JSONEncoder().encode($0) }
      .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
      .flatMap { value in
        Future<Void, Error> { [weak self] promise in
          self?.db.child(DBKey.ChatRooms).child(myUserId).child(object.otherUserId).setValue(value) { error, _ in
            if let error {
              promise(.failure(error))
            } else {
              promise(.success(()))
            }
          }
        }
      }
      .mapError { DBError.error($0) }
      .eraseToAnyPublisher()
  }
}

// 1. 채팅방이 있는지 여부
// 2. 채팅방을 추가하는 메서드
