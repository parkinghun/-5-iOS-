//
//  Review.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation

struct ReviewListModel: Decodable {
  let page: Int
  let results: [Review]
}

struct Review: Decodable {
  let id: String
  let author: Author
  let content: String
  let createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case author = "author_details"
    case content
    case createdAt = "created_at"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let createdAtString = try container.decode(String.self, forKey: .createdAt)
    
    self.id = try container.decode(String.self, forKey: .id)
    self.author = try container.decode(Author.self, forKey: .author)
    self.content = try container.decode(String.self, forKey: .content)
    self.createdAt = createdAtString
  }
}

struct Author: Decodable {
  let name: String
  let username: String
  let avatarURL: String
  let rating: Float
  
  enum CodingKeys: String, CodingKey {
    case name
    case username
    case avatarPath = "avatar_path"
    case rating
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.username = try container.decode(String.self, forKey: .username)
    self.rating = try container.decode(Float.self, forKey: .rating)
    if let avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath) {
      self.avatarURL = "\(APIPath.imageBase.path)\(avatarPath)"
    } else {
      self.avatarURL = ""
    }
  }
}
