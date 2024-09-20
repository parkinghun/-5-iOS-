//
//  Date+Extensions.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/19/24.
//

import Foundation

extension Float {
  var formattedRoundString: String {
    let roundFloat = (self * 100).rounded() / 100
    return "\(roundFloat)"
  }
}
