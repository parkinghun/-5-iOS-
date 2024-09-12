//
//  Network.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation
import RxSwift
import RxAlamofire

final class Network<T: Decodable> {
  private let endpoint: String
  private let queue: ConcurrentDispatchQueueScheduler
  private let apiKey = Bundle.main.apiKey
  
  init(endpoint: String) {
    self.endpoint = endpoint
    self.queue = .init(qos: .background)
  }
  
  // TODO: - 이 다음은 피곤해서 내일...
  func getItemList(endpoint: String, base: String, language: String = "ko") -> Observable<T> {
    let fullPath = "\(endpoint)\(base)?api_key=\(apiKey)&language=\(language)"
    
    return RxAlamofire.data(.get, fullPath)
      .observe(on: queue)
      .debug()
      .map { data -> T in
        return try JSONDecoder().decode(T.self, from: data)
      }
  }
}
