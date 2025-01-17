//
//  AuthenticationViewModel.swift
//  LMessanger
//
//  Created by 박성훈 on 11/27/24.
//

import Foundation
import Combine
import AuthenticationServices

// 로그인 여부
enum AuthenticationState {
  case unauthenticated
  case authenticated
}

final class AuthenticationViewModel: ObservableObject {

  // 명령형(Action-driven) 설계 - MVVM 패턴이나 Flux/Redux 패턴에 영향을 받은 구조에서 많이 사용함
  // 특정 사용자 상호작용이나 이벤트를 하나의 액션으로 캡슐화하고, 이를 ViewModel에서 처리하는 방식
  enum Action {
    case checkAuthenticationState
    case googleLogin
    case appleLogin(ASAuthorizationAppleIDRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
    case logout
  }
  
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var isLoading: Bool = false
  
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  private var currentNonce: String?
  
  var userId: String?
  
  init(container: DIContainer) {
    self.container = container
  }
  
  // 뷰에서 일어나는 액션 관리
  func send(action: Action) {
    switch action {
    case .checkAuthenticationState:
      if let userId = container.services.authService.checkAuthenticationState() {
        self.userId = userId
        self.authenticationState = .authenticated
      }
          
    case .googleLogin:
      isLoading = true
      
      container.services.authService.signInWithGoogle()
        .flatMap { user in
          self.container.services.userService.addUser(user)  // db 추가
        }
        .sink { [weak self] completion in
          if case .failure = completion {
            self?.isLoading = false
            // TODO: - Toast or Alert 작업
          }
        } receiveValue: { [weak self] user in  // output
          self?.isLoading = false
          self?.userId = user.id
          self?.authenticationState = .authenticated
        }.store(in: &subscriptions)
      
    case let .appleLogin(request):
      let nonce = container.services.authService.handleSignInWithAppleRequest(request)
      self.currentNonce = nonce

    case let .appleLoginCompletion(result):
      if case let .success(authorization) = result {
        guard let nonce = currentNonce else { return }
        
        container.services.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
          .flatMap { user in
            self.container.services.userService.addUser(user)  // db 추가
          }
          .sink { [weak self] completion in
            if case .failure = completion {
              self?.isLoading = false
              // TODO: - Toast or Alert 작업
            }
          } receiveValue: { [weak self] user in
            self?.isLoading = false
            self?.userId = user.id
            self?.authenticationState = .authenticated
          }.store(in: &subscriptions)
      } else if case let .failure(error) = result {
        isLoading = false
        print(error.localizedDescription)
      }
    case .logout:
      container.services.authService.logout()
        .sink { completion in
          
        } receiveValue: { [weak self] _ in
          self?.authenticationState = .unauthenticated
          self?.userId = nil
        }.store(in: &subscriptions)
    }
  }
}
