//
//  TV.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation

struct TVListModel:Decodable {
  let page: Int
  let results: [TV]
}

struct TV: Decodable, Hashable {
  let id: Int
  let name: String
  let overview: String
  let posterURL: String
  let firstAirDate: String
  let vote: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case overview
    case posterPath = "poster_path"
    case firstAirDate = "first_air_date"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let posterPath = try container.decode(String.self, forKey: .posterPath)
    let voteAverage = try container.decode(Float.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.posterURL = "\(APIPath.imageBase.path)\(posterPath)"
    self.firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
    self.vote = "\(voteAverage) (\(voteCount))"
  }
}
