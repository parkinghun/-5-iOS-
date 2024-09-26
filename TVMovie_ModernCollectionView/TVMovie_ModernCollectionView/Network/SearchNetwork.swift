//
//  SearchNetwork.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/25/24.
//

import Foundation

final class SearchNetwork {
  private let network: Network<TVListModel>
  
  init(network: Network<TVListModel>) {
    self.network = network
  }
  
  public func getSearchedTVList() {
    
  }
}
