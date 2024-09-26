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
  
  init(_ endpoint: String) {
    self.endpoint = endpoint
    self.queue = .init(qos: .background)
  }
  
  func getItemList(base: String, isEnglish: Bool = false, page: Int? = nil, query: String? = nil) -> Observable<T> {
    var fullPath = "\(endpoint)\(base)?api_key=\(apiKey)&language=\(isEnglish ? "en" : "ko")"
    
    if let page = page {
      fullPath += "&page=\(page)"
    }
    
    // 비영어권언어나 특수 문자는 URL에 직접 포함할 수 없기 때문에 Percent Encoding 해줘야 한다.
    if let query = query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      fullPath += "&query=\(query)"
    }
    
    print("🐶 Path: \(fullPath)")
    return RxAlamofire.data(.get, fullPath)
      .observe(on: queue)
      .debug()
      .map { data -> T in
        return try JSONDecoder().decode(T.self, from: data)
      }
  }
}
 
