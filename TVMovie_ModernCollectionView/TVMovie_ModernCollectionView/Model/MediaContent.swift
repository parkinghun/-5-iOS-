//
//  CommonItem.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation

struct MediaContent: Hashable {
  var id: Int
  var posterURL: String
  var title: String
  var vote: String
  var overview: String
  var releaseDate: String
  var contentType: ContentType
  
  init(from media: TV) {
    self.id = media.id
    self.posterURL = media.posterURL
    self.title = media.name
    self.vote = media.vote
    self.overview = media.overview
    self.releaseDate = media.firstAirDate
    self.contentType = media.contentType
  }
  
  init(from media: Movie) {
    self.id = media.id
    self.posterURL = media.posterURL
    self.title = media.title
    self.vote = media.vote
    self.overview = media.overview
    self.releaseDate = media.releaseDate
    self.contentType = media.contentType
  }
}

protocol ContentItem {
  var id: Int { get }
  var contentType: ContentType { get }
}
