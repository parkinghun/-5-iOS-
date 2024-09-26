//
//  NetworkProvider.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation
import RxSwift

final class NetworkProvider {
  private let endpoint: String
  
  init() {
    self.endpoint = APIPath.endpoint.path
  }
  
  func makeTVNetowrk() -> TVNetwork {
    let network = Network<TVListModel>(endpoint)
    return TVNetwork(netowrk: network)
  }
  
  func makeMovieNetowrk() -> MovieNetwork {
    let network = Network<MovieListModel>(endpoint)
    return MovieNetwork(network: network)
  }
  
  func makeReviewNetwork() -> ReviewNetwork {
    let network = Network<ReviewListModel>(endpoint)
    return ReviewNetwork(network: network)
  }
}
