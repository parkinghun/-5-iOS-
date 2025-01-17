//
//  NavigationRouter.swift
//  LMessanger
//
//  Created by 박성훈 on 1/17/25.
//

import Foundation

class NavigationRouter: ObservableObject {
  @Published var destination: [NavigationDestination] = []
  
  func push(to view: NavigationDestination) {
    destination.append(view)
  }
  
  func pop() {
    _ = destination.popLast()
  }
  
  func popToRootView() {
    destination = []
  }
}
