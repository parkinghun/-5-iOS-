//
//  MemoryStorage.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import UIKit

protocol MemoryStorageType {
  func value(for key: String) -> UIImage?
  func store(for key: String, image: UIImage)
}

class MemoryStorage: MemoryStorageType {
  // 키는 NSString, value는 UIImage로 저장
  // NS계열이기 때문에 두 타입 다 클래스 타입이어야 함
  var cache = NSCache<NSString, UIImage>()
  
  // NSCache를 이용해서 메모리 캐시에서 이미지 획득
  func value(for key: String) -> UIImage? {
    return cache.object(forKey: NSString(string: key))
  }
  
  // NSCache를 이용해서 이미지를 메모리 캐시에 저장
  func store(for key: String, image: UIImage) {
    cache.setObject(image, forKey: NSString(string: key))
  }
}
