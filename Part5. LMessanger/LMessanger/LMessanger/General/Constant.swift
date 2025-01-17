//
//  Constant.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation

// Constant.DBKey.Users -> DBKey.Users
typealias DBKey = Constant.DBKey

// 네임스페이싱
enum Constant { }

extension Constant {
  struct DBKey {
    static let Users = "Users"
    static let ChatRooms = "ChatRooms"
    static let Chats = "Chats"
  }
}
