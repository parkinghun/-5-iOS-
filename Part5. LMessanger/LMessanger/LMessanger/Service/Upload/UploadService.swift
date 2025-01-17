//
//  UploadService.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import Foundation

// 이미지 업로드 경로 - 프로필, 채팅 -> 경로 관리 enum
protocol UploadServiceType {
  func uploadImage(source: UploadSourceType, data: Data) async throws -> URL
}

class UploadService: UploadServiceType {
  private let provider: UploadProviderType
  
  init(provider: UploadProviderType) {
    self.provider = provider
  }
  
  func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
    let url = try await provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
    return url
  }
}

class StubUploadService: UploadServiceType {
  func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
    return URL(string: "")!
  }
}
