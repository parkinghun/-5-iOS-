//
//  Movie.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation

struct MovieListModel {
  let page: Int
  let results: [Movie]
}

struct Movie: Decodable {
  let id: Int
  let title: String
  let overview: String
  let posterURL: String
  let releaseDate: Date?
  let vote: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let posterPath = try container.decode(String.self, forKey: .posterPath)
    let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
    let voteAverage = try container.decode(Float.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.posterURL = "\(APIPath.imageBase)\(posterPath)"
    self.releaseDate = releaseDateString.formattedDate
    self.vote = "\(voteAverage) (\(voteCount))"
  }
}
