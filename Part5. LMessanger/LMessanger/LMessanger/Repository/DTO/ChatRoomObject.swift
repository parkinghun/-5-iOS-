//
//  ChatRoomObject.swift
//  LMessanger
//
//  Created by 박성훈 on 1/15/25.
//

import Foundation

struct ChatRoomObject: Codable {
  var chatRoomId: String
  var lastMessage: String?
  var otherUserName: String
  var otherUserId: String
}

extension ChatRoomObject {
  func toModel() -> ChatRoom {
    .init(chatRoomId: chatRoomId,
          lastMessage: lastMessage,
          otherUserName: otherUserName,
          otherUserId: otherUserId)
  }
}
