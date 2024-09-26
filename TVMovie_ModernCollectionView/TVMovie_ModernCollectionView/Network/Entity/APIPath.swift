//
//  APIPath.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation

enum APIPath {
  case tvTopRated
  case movieNowPlaying
  case moviePopular
  case movieUpcoming
  case tvReviews(seriesID: Int)
  case movieReviews(movieID: Int)
  case searchTV
  case endpoint
  case imageBase
  
  var path: String {
    switch self {
    case .tvTopRated: return "/tv/top_rated"
    case .movieNowPlaying: return "/movie/now_playing"
    case .moviePopular: return "/movie/popular"
    case .movieUpcoming: return "/movie/upcoming"
    case .tvReviews(let id): return "/tv/\(id)/reviews"
    case .movieReviews(let id): return "/movie/\(id)/reviews"
    case .searchTV: return "/search/tv"
    case .endpoint: return "https://api.themoviedb.org/3"
    case .imageBase: return "https://image.tmdb.org/t/p/w500"
    }
  }
}

