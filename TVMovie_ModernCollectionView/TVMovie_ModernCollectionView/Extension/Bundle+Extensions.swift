//
//  Bundle+Extensions.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation

extension Bundle {
  var apiKey: String {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "APIKEY") as? String else {
      print("🙅🏻‍♂️ api 키 가져오기 실패")
      return "err"
    }
    print("🔐 APIKEY - \(key)")
    return key
  }
}
