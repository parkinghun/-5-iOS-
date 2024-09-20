//
//  CommonItem.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation

struct CommonItem: Hashable {
  let thumbnailURL: String
  let title: String
  let vote: String
  let overview: String
  let releaseDate: String
  
  init(with tv: TV) {
    self.thumbnailURL = tv.posterURL
    self.title = tv.name
    self.vote = tv.vote
    self.overview = tv.overview
    self.releaseDate = tv.firstAirDate
  }
  
  init(with movie: Movie) {
    self.thumbnailURL = movie.posterURL
    self.title = movie.title
    self.vote = movie.vote
    self.overview = movie.overview
    self.releaseDate = movie.releaseDate
  }
}
