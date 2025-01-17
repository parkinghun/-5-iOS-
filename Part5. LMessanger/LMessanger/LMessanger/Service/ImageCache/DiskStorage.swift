//
//  DiskStorage.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import UIKit

protocol DiskStorageType {
  func value(for key: String) throws -> UIImage?
  func store(for key: String, image: UIImage) throws
}

// ETage를 활용하면 더 좋은 캐시를 만들 수 있다?
class DiskStorage: DiskStorageType {
  let fileManager: FileManager
  let directoryURL: URL
  
  init(fileManager: FileManager = .default) {
    self.fileManager = fileManager
    // 캐시 저장경로
    self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")  // cache/ImageCache
    
    createDirectory()
  }
  
  // 저장할 캐시 아래에 ImageCache 디렉토리까지 생성(Cache/ImageCache)
  func createDirectory() {
    guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
    
    do {  // 없으면 생성
      try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    } catch {
      print(error)
    }
  }
  
  // 이미지파일 이름은 sha256으로 생성하여 만듦
  private func cacheFileURL(for key: String) -> URL {
    let fileName = sha256(key)
    return directoryURL.appendingPathComponent(fileName, isDirectory: false)
  }
  
  // key로 URL이 넘어오기 때문에 /와 같은 문자가 섞여있을 수 있어 경로를 sha암호화를 이용해 파일이름을 만듦
  func value(for key: String) throws -> UIImage? {
    let fileURL = cacheFileURL(for: key)
    
    guard fileManager.fileExists(atPath: fileURL.path()) else {
      return nil
    }
    
    let data = try Data(contentsOf: fileURL)
    return UIImage(data: data)
  }
  
  // 해당 URL을 가진 이미지가 Memory Storage, Disk Storage 둘 다 없을 때 호출됨
  func store(for key: String, image: UIImage) throws {
    // 이미지는 네트워크 통신을 한 이후의 결과물 -> 캐시 디렉토리에 저장
    let data = image.jpegData(compressionQuality: 0.5)
    let fileURL = cacheFileURL(for: key)
    try data?.write(to: fileURL)
  }
}
