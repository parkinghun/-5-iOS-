//
//  MovieNetwork.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation
import RxSwift

final class MovieNetwork {
  private let network: Network<MovieListModel>
  
  init(network: Network<MovieListModel>) {
    self.network = network
  }
  
  func getNowPlayingList() -> Observable<MovieListModel> {
    return network.getItemList(base: APIPath.movieNowPlaying.path)
  }
  
  func getPopularList() -> Observable<MovieListModel> {
    return network.getItemList(base: APIPath.moviePopular.path)
  }
  
  func getUpcomingList() -> Observable<MovieListModel> {
    return network.getItemList(base: APIPath.movieUpcoming.path)
  }
}
