//
//  MainTabType.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
  case home
  case chat
  case phone
  
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .chat:
      return "대화"
    case .phone:
      return "통화"
    }
  }
  
  func imageName(selected: Bool) -> String {
    selected ? "\(rawValue)_fill" : rawValue
  }
}
