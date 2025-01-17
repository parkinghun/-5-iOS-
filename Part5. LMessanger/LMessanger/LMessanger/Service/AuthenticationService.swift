//
//  AuthenticationService.swift
//  LMessanger
//
//  Created by 박성훈 on 11/29/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

enum AuthenticationError: Error {
  case clientIDError
  case tokenError
  case invalidated
}

protocol AuthenticationServiceType {
  func checkAuthenticationState() -> String?
  func signInWithGoogle() -> AnyPublisher<User, ServiceError>
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
  func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError>
  func logout() -> AnyPublisher<Void, ServiceError>
}

final class AuthenticationService: AuthenticationServiceType {
  
  func checkAuthenticationState() -> String? {
    if let user = Auth.auth().currentUser {
      return user.uid
    } else {
      return nil
    }
  }
  
  func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
    Future { [weak self] promise in
      self?.signInWithGoogle { result in  // completionHandler(Result) -> Publisher(Result)
        switch result {
        case let .success(user):
          promise(.success(user))
        case let .failure(error):
          promise(.failure(.error(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  /// 요청이 왔을 때 해당하는 리퀘스트의 nonce와 원하는 정보에 대한 범위를 request 안에 포함해서 넘겨줌
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
    request.requestedScopes = [.fullName, .email]

    let nonce = randomNonceString()
    request.nonce = sha256(nonce)
    
    return nonce
  }
  
  /// 인증에 대한 성공 정보가 authorization 안에 있기 때문에 로그인 요청이 맞는지에 대한 nonce를 파라미터로 받아서 처리
  func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError> {
    Future { [weak self] promise in
      self?.handleSignInWithAppleCompletion(authorization, nonce: nonce) { result in
        switch result {
        case let .success(user):
          promise(.success(user))
        case let .failure(error):
          promise(.failure(.error(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func logout() -> AnyPublisher<Void, ServiceError> {
    Future { promise in
      do {
        try Auth.auth().signOut()
        promise(.success(()))
      } catch {
        promise(.failure(.error(error)))
      }
    }.eraseToAnyPublisher()
  }
}

// MARK: - AuthService Mehtods
extension AuthenticationService {
  private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      completion(.failure(AuthenticationError.clientIDError))
      return
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      return
    }
    
    // Google 로그인 프로세스를 시작 - 이 시점에서 사용자는 Google 로그인 화면을 보게 된다.
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result ,error in
      if let error {
        completion(.failure(error))
        return
      }
      
      guard let user = result?.user,
            let idToken = user.idToken?.tokenString else {
        completion(.failure(AuthenticationError.tokenError))
        return
      }
      
      let accessToken = user.accessToken.tokenString
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
      
      self.authenticateUserWithFirebase(credential: credential, completion: completion)
    }
  }
  
  // authorization로 credential을 만듦, credential로 파이어베이스 인증을 진행함
  private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization,
                                               nonce: String,
                                               completion: @escaping (Result<User, Error>) -> Void) {
    
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let appleIDToken = appleIDCredential.identityToken else {
      completion(.failure(AuthenticationError.tokenError))
      return
    }
    
    guard let  idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      completion(.failure(AuthenticationError.tokenError))
      return
    }
    
    let credential = OAuthProvider.credential(providerID: .apple,
                             idToken: idTokenString,
                             rawNonce: nonce)
    
    // 완료됐을 때 해당 클로저가 호출되는데, 파이어베이스 정보를 담는 부분이 충분히 넘어오지 않기 때문에 유저정보를 해당 클로저에서 변경하여 원하는 데이터로 만듦
    authenticateUserWithFirebase(credential: credential) { result in
      switch result {
      case var .success(user):
        user.name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
          .compactMap { $0 }
          .joined(separator: " ")
        completion(.success(user))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  /// 파이어베이스 인증
  private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
    Auth.auth().signIn(with: credential) { result, error in
      if let error {
        completion(.failure(error))
        return
      }
      
      guard let result else {
        completion(.failure(AuthenticationError.invalidated))
        return
      }
      
      let firebaseUser = result.user
      let user: User = .init(id: firebaseUser.uid,
                             name: firebaseUser.displayName ?? "",
                             phoneNumber: firebaseUser.phoneNumber,
                             profileURL: firebaseUser.photoURL?.absoluteString)
      
      completion(.success(user))
    }
  }
}

// MARK: - StubAuthService
// preview에서 사용하는 용도
final class StubAuthenticationService: AuthenticationServiceType {
  func checkAuthenticationState() -> String? {
    return nil
  }
  
  func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
    return ""
  }
  
  func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func logout() -> AnyPublisher<Void, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
}
