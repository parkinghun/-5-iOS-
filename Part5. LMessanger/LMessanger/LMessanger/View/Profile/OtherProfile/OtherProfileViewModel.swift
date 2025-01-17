//
//  OtherProfileViewModel.swift
//  LMessanger
//
//  Created by 박성훈 on 1/13/25.
//

import Foundation

@MainActor
class OtherProfileViewModel: ObservableObject {
  @Published var userInfo: User?
  
  private let container: DIContainer
  private var userId: String

  init(container: DIContainer, userId: String) {
    self.container = container
    self.userId = userId
  }
  
  func getUser() async {
    if let user = try? await container.services.userService.getUser(userId: userId) {
      userInfo = user
    }
  }
}
