//
//  LMessangerApp.swift
//  LMessanger
//
//  Created by 박성훈 on 11/27/24.
//

import SwiftUI

@main
struct LMessangerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var container: DIContainer = .init(services: Services())
  
  // View or ViewModel을 테스트 할 때 원하는 형태로 주입하여 테스트 할 수 있음
  var body: some Scene {
    WindowGroup {
      AuthenticatedView(authViewModel: .init(container: container),
                        navigationRouter: .init())
        .environmentObject(container)
    }
  }
}
