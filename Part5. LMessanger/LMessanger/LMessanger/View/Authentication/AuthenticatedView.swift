//
//  AuthenticatedView.swift
//  LMessanger
//
//  Created by 박성훈 on 11/27/24.
//

import SwiftUI

struct AuthenticatedView: View {
  @StateObject var authViewModel: AuthenticationViewModel
  @StateObject var navigationRouter: NavigationRouter
  
  var body: some View {
    VStack {
      switch authViewModel.authenticationState {
      case .unauthenticated:
        LoginIntroView()
          .environmentObject(authViewModel)
      case .authenticated:
        MainTabView()
          .environmentObject(authViewModel)
          .environmentObject(navigationRouter)
      }
    }
    .onAppear {
      authViewModel.send(action: .checkAuthenticationState)
    }
  }
}

#Preview {
  AuthenticatedView(authViewModel: .init(container: .init(services: StubService())), navigationRouter: .init())
}
