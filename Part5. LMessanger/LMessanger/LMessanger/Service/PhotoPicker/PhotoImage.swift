//
//  PhotoImage.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import SwiftUI

struct PhotoImage: Transferable {
  let data: Data
  
  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      // 원본에 대한 이미지 데이터이므로 용량이 커서 jpeg로 압축해야 함.
      guard let uiImage = UIImage(data: data) else {
        throw PhotosPickerError.importFailed
      }
      
      guard let data = uiImage.jpegData(compressionQuality: 0.3) else {
        throw PhotosPickerError.compressFailed
      }
      
      return PhotoImage(data: data)
    }
  }
}
