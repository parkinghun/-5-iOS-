//
//  DIContainer.swift
//  LMessanger
//
//  Created by 박성훈 on 11/27/24.
//

import Foundation

// Service 관리
final class DIContainer: ObservableObject {
  var services: ServiceType
  
  init(services: ServiceType) {
    self.services = services
  }
}
