//
//  MyProfileViewModel.swift
//  LMessanger
//
//  Created by 박성훈 on 1/6/25.
//

import SwiftUI
import PhotosUI

@MainActor  // 해당 클래스 안에 있는 프로퍼티는 메인 액터에서 엑세스 할 수 있음
class MyProfileViewModel: ObservableObject {
  
  @Published var userInfo: User?
  @Published var isPresentedDescEditView: Bool = false
  @Published var imageSelection: PhotosPickerItem? {  // placeholder에 대한 정보만 담고있음
    didSet {
      Task {
        await updateProfileImage(pickerItem: imageSelection)
      }
    }
  }
  
  private let userId: String
  private var container: DIContainer
  
  // 프로필에서 최신정보를 보여주기 위해 파라미터로 userId를 받음
  init(container: DIContainer, userId: String) {
    self.container = container
    self.userId = userId
  }
  
  func getUser() async {
    if let user = try? await container.services.userService.getUser(userId: userId) {
      userInfo = user
    }
  }
  
  func updateDescription(_ description: String) async {
    do {
      try await container.services.userService.updateDescription(userId: userId, description: description)
      userInfo?.description = description
    } catch {
      
    }
  }
  
  func updateProfileImage(pickerItem: PhotosPickerItem?) async {
    guard let pickerItem else { return }
    
    do {
      let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
      let url = try await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: data)
      try await container.services.userService.updateProfileURL(userId: userId, urlString: url.absoluteString)
      
      userInfo?.profileURL =  url.absoluteString
    } catch {
      print(error.localizedDescription)
    }
  }
  
}
