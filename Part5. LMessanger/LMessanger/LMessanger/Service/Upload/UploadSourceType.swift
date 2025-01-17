//
//  UploadSourceType.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import Foundation

enum UploadSourceType {
  case chat(chatRoomId: String)
  case profile(userId: String)
  
  var path: String {
    // 이렇게 했을 때 이점 - 채팅방, 유저가 삭제될 때 안에 있는 경로의 이미지들을 모두 지울 수 있다.
    switch self {
    case let .chat(chatRoomId):  // Chats/chatRoomId
      return "\(DBKey.Chats)/\(chatRoomId)"
    case let .profile(userId):  // Users/UiserId/
      return "\(DBKey.Users)/\(userId)"
    }
  }
}
