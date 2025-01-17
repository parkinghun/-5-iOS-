//
//  HomeRecommenViewModel.swift
//  KTV
//
//  Created by 박성훈 on 11/13/24.
//

import Foundation

final class HomeRecommendViewModel {
  private(set) var isFolded: Bool = true {
    didSet {
      self.foldChanged?(self.isFolded)
    }
  }
  
  var foldChanged: ((Bool) -> Void)?
  
  var recommends: [Home.Recommend]?
  var itemCount: Int {
    let count = self.isFolded ? 5 : self.recommends?.count ?? 0
    return min(self.recommends?.count ?? 0, count)
  }
  
  func toggleFoldState() {
    self.isFolded.toggle()
  }
}
