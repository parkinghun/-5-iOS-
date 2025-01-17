//
//  HomeViewModel.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
  
  enum Action {
    case load
    case reqeustContacts
    case presentMyProfileView
    case presentOtherProfileView(String)
    case goToChat(User)
  }
  
  @Published var myUser: User?
  @Published var users: [User] = []
  @Published var phase: Phase = .notRequested
  @Published var modalDestination: HomeModalDestination?
  
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  var userId: String

  init(container: DIContainer, userId: String) {
    self.container = container
    self.userId = userId
  }
  
  func send(action: Action) {
    switch action {
    case .load:
      phase = .loading
      
      container.services.userService.getUser(userId: userId)
        .handleEvents(receiveOutput: { [weak self] user in  // TODO: - 공부하기
          self?.myUser = user
        })  // 스트림의 사이드 이펙트, 스트림에 대해서 이벤트 중간에 어떤 작업을 하고싶을 때 사용함.
        .flatMap { user in
          self.container.services.userService.loadUser(id: user.id)
        }.sink { [weak self] completion in
          if case .failure = completion {
            self?.phase = .fail
          }
        } receiveValue: { [weak self] users in
          self?.phase = .success
          self?.users = users
        }.store(in: &subscriptions)
      
    case .reqeustContacts:
      container.services.contactService.fetchContacts()
        .flatMap { users in  // db에 추가하기
          self.container.services.userService.addUserAfterContact(users: users)
        }
        .flatMap { _ in  // 추가 후 유저 정보 가져오기
          self.container.services.userService.loadUser(id: self.userId)
        }
        .sink { [weak self] completion in
          if case .failure = completion {
            self?.phase = .fail
          }
        } receiveValue: { [weak self] users in
          self?.phase = .success
          self?.users = users
        }.store(in: &subscriptions)

    case .presentMyProfileView:
      modalDestination = .myProfile
      
    case let .presentOtherProfileView(userId):
      modalDestination = .otherProfile(userId)
      
    case let .goToChat(otherUser):
      // 채팅방에 들어가야 함. -> 채팅방 있는지 확인 후 없으면 생성
      // 채팅방 목록 - ChatRoom/myUserId/otherUserId
      container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
        .sink { completion in
          
        } receiveValue: { chatRoom in
          // TODO: 채팅뷰로 navigation
        }.store(in: &subscriptions)

    }
  }
}
