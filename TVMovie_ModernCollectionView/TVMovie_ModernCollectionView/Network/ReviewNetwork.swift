//
//  ReviewNetwork.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/20/24.
//

import Foundation
import RxSwift

final class ReviewNetwork {
  private let network: Network<ReviewListModel>
  
  init(network: Network<ReviewListModel>) {
    self.network = network
  }
  
  func getReviewList(contentID: Int, contentType: ContentType) -> Observable<ReviewListModel> {
    return network.getItemList(
      base: contentType == .tv ?
      APIPath.tvReviews(seriesID: contentID).path :
        APIPath.movieReviews(movieID: contentID).path,
      isEnglish: true
    )
  }
}
