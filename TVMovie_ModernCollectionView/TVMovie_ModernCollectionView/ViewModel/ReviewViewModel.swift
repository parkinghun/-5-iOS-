//
//  ReviewViewModel.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/23/24.
//

import Foundation
import RxSwift

final class ReviewViewModel: ViewModelType {
  private let reviewNetwork: ReviewNetwork
  private let id: Int
  let contentType: ContentType
  var disposeBag = DisposeBag()

  init(id: Int, contentType: ContentType) {
    let provider = NetworkProvider()
    self.reviewNetwork = provider.makeReviewNetwork()
    self.id = id
    self.contentType = contentType
  }
  
  func transform(input: Input) -> Output {
    let reviewResult: Observable<Result<[Review], Error>> = reviewNetwork.getReviewList(contentID: id, contentType: contentType).map { reviewListModel in
      print(reviewListModel.results)
      return .success(reviewListModel.results)
    }.catch { error in
      return Observable.just(.failure(error))
    }
    
    return Output(reviewResult: reviewResult)
  }
}

extension ReviewViewModel {
  struct Input { }
  struct Output {
    let reviewResult: Observable<Result<[Review], Error>>
  }
}
