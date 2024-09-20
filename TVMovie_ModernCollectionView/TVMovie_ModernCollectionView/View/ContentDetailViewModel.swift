//
//  ContentDetailViewModel.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/20/24.
//

import UIKit
import RxSwift

final class ContentDetailViewModel: ViewModelType {
  struct Input {
    // 리뷰보기 버튼을 누르면
  }
  
  struct Output {
    // 리뷰 데이터 패치해서 보여주기
  }
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    return Output()
  }
}

