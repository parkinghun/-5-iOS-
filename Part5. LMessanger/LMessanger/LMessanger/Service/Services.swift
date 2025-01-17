//
//  Services.swift
//  LMessanger
//
//  Created by 박성훈 on 11/27/24.
//

import Foundation

// 서비스 틀 만들기
// 프로토콜 지향 프로그래밍
protocol ServiceType {
  var authService: AuthenticationServiceType { get set }
  var userService: UserServiceType { get set }
  var contactService: ContactServiceType { get set }
  var photoPickerService: PhotoPickerServiceType { get set }
  var uploadService: UploadServiceType { get set }
  var imageCacheService: ImageCacheServiceType { get set }
  var chatRoomService: ChatRoomServiceType { get set }
}

final class Services: ServiceType {
  var authService: AuthenticationServiceType
  var userService: UserServiceType
  var contactService: ContactServiceType
  var photoPickerService: PhotoPickerServiceType
  var uploadService: UploadServiceType
  var imageCacheService: ImageCacheServiceType
  var chatRoomService: ChatRoomServiceType
  
  init() {
    self.authService = AuthenticationService()
    self.userService = UserService(dbRepository: UserDBRepository())
    self.contactService = ContactService()
    self.photoPickerService = PhotoPickerService()
    self.uploadService = UploadService(provider: UploadProvider())
    self.imageCacheService = ImageCacheService(memoryStoage: MemoryStorage(), diskStorage: DiskStorage())
    self.chatRoomService = ChatRoomService(dbRepositroty: ChatRoomDBRepository())
  }
}

final class StubService: ServiceType {
  var authService: AuthenticationServiceType = StubAuthenticationService()
  var userService: UserServiceType = StubUserService()
  var contactService: ContactServiceType = StubContactService()
  var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
  var uploadService: UploadServiceType = StubUploadService()
  var imageCacheService: ImageCacheServiceType = StubImageCacheService()
  var chatRoomService: ChatRoomServiceType = StubChatRoomService()
}
