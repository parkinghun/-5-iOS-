//
//  ContentDetailViewModel.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/20/24.
//

import UIKit
import RxSwift

final class ContentDetailViewModel {
  let contentType: ContentType
  let contentID: Int
  
  init(contentType: ContentType, contentID: Int) {
    self.contentType = contentType
    self.contentID = contentID
    let provider = NetworkProvider()
  }
}

