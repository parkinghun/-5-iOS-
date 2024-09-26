//
//  TVNetwork.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation
import RxSwift

final class TVNetwork {
  private let network: Network<TVListModel>
  
  init(netowrk: Network<TVListModel>) {
    self.network = netowrk
  }
  
  func getTopRatedList(page: Int) -> Observable<TVListModel> {
    return network.getItemList(base: APIPath.tvTopRated.path, page: page)
  }
  
  func getQuriedList(page: Int, query: String) -> Observable<TVListModel> {
    return network.getItemList(base: APIPath.searchTV.path, page: page, query: query)
  }
}
