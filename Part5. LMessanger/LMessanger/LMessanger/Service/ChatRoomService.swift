//
//  ChatRoomService.swift
//  LMessanger
//
//  Created by 박성훈 on 1/15/25.
//

import Foundation
import Combine

protocol ChatRoomServiceType {
  func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError>
}

class ChatRoomService: ChatRoomServiceType {
  private let dbRepository: ChatRoomDBRepositoryType
  
  init(dbRepositroty: ChatRoomDBRepositoryType) {
    self.dbRepository = dbRepositroty
  }
  
  func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
    dbRepository.getChatRoom(myUserId: myUserId, otherUserId: otherUserId)
      .mapError {ServiceError.error($0) }
      .flatMap { object in
        // 채티룸 오브젝트가 있을 시 아웃풋으로 보내주고, 없으면 addChatRoom
        if let object {
          return Just(object.toModel()).setFailureType(to: ServiceError.self).eraseToAnyPublisher( )
        } else {
          let newChatRoom: ChatRoom = .init(chatRoomId: UUID().uuidString, otherUserName: otherUserName, otherUserId: otherUserId)
          return self.addChatRoom(newChatRoom, to: myUserId)
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func addChatRoom(_ chatRoom: ChatRoom, to myUserId: String) -> AnyPublisher<ChatRoom, ServiceError> {
    dbRepository.addChatRoom(chatRoom.toObject(), myUserId: myUserId)
      .map { chatRoom }
      .mapError { .error($0) }
      .eraseToAnyPublisher( )
  }
}

class StubChatRoomService: ChatRoomServiceType {
  func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
}


