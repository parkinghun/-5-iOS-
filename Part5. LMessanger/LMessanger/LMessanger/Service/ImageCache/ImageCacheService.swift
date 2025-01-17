//
//  ImageCacheService.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
  func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType {
  let memoryStoage: MemoryStorage
  let diskStorage: DiskStorage
  
  init(memoryStoage: MemoryStorage, diskStorage: DiskStorage) {
    self.memoryStoage = memoryStoage
    self.diskStorage = diskStorage
  }
  
  func image(for key: String) -> AnyPublisher<UIImage?, Never> {
    imageWithMemoryCache(for: key)
      .flatMap { image -> AnyPublisher<UIImage?, Never> in
        if let image {
          return Just(image).eraseToAnyPublisher()  // 있으면 값을 보내주고
        } else {
          return self.imageWithDiskCache(for: key)  // 없으면 디스크스토리지 체크
        }
      }
      .eraseToAnyPublisher()
  }
  
  // 1. 메모리 캐시에 이미지 캐시가 있는지 확인
  private func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
    Future { [weak self] promise in
      let image = self?.memoryStoage.value(for: key)
      promise(.success(image))
    }.eraseToAnyPublisher()
  }
  
  // 2. 없으면 디스크 캐시 확인
  private func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
    Future<UIImage?, Never> { [weak self] promise in
      do {
        let image = try self?.diskStorage.value(for: key)
        promise(.success(image))
      } catch {
        promise(.success(nil))
      }
    }.flatMap { image -> AnyPublisher<UIImage?, Never> in
      if let image {  // 있으면 리턴  // 메모리 캐시에 없는 경우
        return Just(image)
          .handleEvents(receiveOutput: { [weak self] image in
            guard let image else { return }
            self?.store(for: key, image: image, toDisk: false)
          })
          .eraseToAnyPublisher()
      } else {  // 없으면 remote
        return self.remoteImage(for: key)
      }
    }
    .eraseToAnyPublisher()
  }

  // 3. 없으면 네트워크 통신, 핸들 이벤트로 저장
  private func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
    URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
      .map { data, _ in
        UIImage(data: data)
      }
      .replaceError(with: nil)  // Error가 있으면 nil로 치환
      .handleEvents(receiveOutput: { [weak self] image in
        guard let image else { return }
        self?.store(for: urlString, image: image, toDisk: true)
      })
      .eraseToAnyPublisher()
  }
  
  // 만약에 실제 URLSession으로 정보를 받아왔다면 스토리지에 저장
  // 디스크 스토리지에만 있는경우라면 memory cache에 저장(앱을 종료하여 디스크캐시만 남아아있는 경우)
  private func store(for key: String, image: UIImage, toDisk: Bool) {
    memoryStoage.store(for: key, image: image)
    
    if toDisk {
      try? diskStorage.store(for: key, image: image)
    }
  }
  
  // TODO: - 보안작업: Disk Storage에 expired date와 용량에 대한 내용을 추가하는 것
  // 만료기한을 두어 어느 시점이 되면 캐시를 지우도록 함 + 정해진 용량이 차면 캐시 정리
}



class StubImageCacheService: ImageCacheServiceType {
  func image(for key: String) -> AnyPublisher<UIImage?, Never> {
    Empty().eraseToAnyPublisher()
  }
}
