//
//  ImagePickerService.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import Foundation
import SwiftUI
import PhotosUI

enum PhotosPickerError: Error {
  case importFailed
  case compressFailed
}

protocol PhotoPickerServiceType {
  func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

class PhotoPickerService: PhotoPickerServiceType {
  // 이해 안감...
  func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
    guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
      throw PhotosPickerError.importFailed
    }
    return image.data
  }
}

class StubPhotoPickerService: PhotoPickerServiceType {
  func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
    return Data()
  }
}
