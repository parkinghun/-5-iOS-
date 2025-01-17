//
//  HomeModalDestination.swift
//  LMessanger
//
//  Created by 박성훈 on 1/4/25.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
  case myProfile
  case otherProfile(String)  // userId를 파라미터로 받음
  
  var id: Int {  // 계산속성을 통해 각 케이스에 고유한 id 값을 생성해줌
    hashValue
  }
}
