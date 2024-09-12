//
//  HomeSection.swift
//  KTV
//
//  Created by 박성훈 on 7/30/24.
//

import Foundation

// section을 enum으로 처리하면 Case에서 Other를 추가했을 때 case 누락을 빠르게 파악할 수 있다 -> 휴먼 에러를 방지할 수 있음
enum HomeSection: Int, CaseIterable {
  case header
  case video
  case ranking
  case recentWatch
  case recommend
  case footer
}
