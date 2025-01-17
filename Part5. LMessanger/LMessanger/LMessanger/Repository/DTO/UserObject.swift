//
//  UserObject.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation

// DTO - Data Transfer Object, 데이터 전송 객체
struct UserObject: Codable {
  var id: String
  var name: String
  var phoneNumber: String?
  var profileURL: String?
  var description: String?
}

extension UserObject {
  func toModel() -> User {
    .init(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      profileURL: profileURL,
      description: description
    )
  }
}
