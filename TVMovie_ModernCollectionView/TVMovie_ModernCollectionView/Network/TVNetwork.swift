//
//  TVNetwork.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation
import RxSwift

// 20개씩 받도록?
// TODO: - 1. topRatedList(infiniteScroll) / 2. searchTVList
final class TVNetwork {
  private let netowrk: Network<TVListModel>
  
  init(netowrk: Network<TVListModel>) {
    self.netowrk = netowrk
  }
  
  func getTopRatedList(page: Int) -> Observable<TVListModel> {
    return netowrk.getItemList(base: APIPath.tvTopRated.path, page: page)
  }
  
}
