//
//  UploadProvider.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import Foundation
import FirebaseStorage

protocol UploadProviderType {
  func upload(path: String, data: Data, fileName: String) async throws -> URL
}

class UploadProvider: UploadProviderType {
  // reference - 클라우드의 파일을 가르키는 포인터
  let storageRef = Storage.storage().reference()
  
  func upload(path: String, data: Data, fileName: String) async throws -> URL {
    let ref = storageRef.child(path).child(fileName)
    let _ = try await ref.putDataAsync(data)
    let url = try await ref.downloadURL()  // 업로드된 url 받아오기
    
    return url
  }
}
