//
//  ChatRoom.swift
//  LMessanger
//
//  Created by 박성훈 on 1/17/25.
//

import Foundation

struct ChatRoom: Codable {
  var chatRoomId: String
  var lastMessage: String?
  var otherUserName: String
  var otherUserId: String
}

extension ChatRoom {
  func toObject() -> ChatRoomObject {
    .init(chatRoomId: chatRoomId,
          lastMessage: lastMessage,
          otherUserName: otherUserName,
          otherUserId: otherUserId)
  }
}
