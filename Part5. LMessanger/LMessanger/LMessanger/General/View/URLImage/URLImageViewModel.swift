//
//  URLImageViewModel.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
  
  // 로딩이 시작되었거나 이미 이미지를 가져온 경우 다시 가져오지 않게 체크하는 역할
  var loadingOrSuccess: Bool {
    return loading || loadedImage != nil
  }
  
  @Published var loadedImage: UIImage?
  
  private var urlString: String
  private var container: DIContainer
  private var loading: Bool = false
  private var subscriptions = Set<AnyCancellable>()
  
  init(container: DIContainer, urlString: String) {
    self.container = container
    self.urlString = urlString  // 이미지에 대한 url
  }
  
  func start() {
    guard !urlString.isEmpty else { return }
    
    loading = true
    
    // 캐시에서 하는 작업, 특히 디스크 캐시에서 하는 작업들은 긴 작업이므로 글로벌 큐에서 동작해야함
    container.services.imageCacheService.image(for: urlString)
      .subscribe(on: DispatchQueue.global())  // 위의 작업
      .receive(on: DispatchQueue.main)  // 결과 받을 때
      .sink { [weak self] image in
        self?.loading = false
        self?.loadedImage = image
      }.store(in: &subscriptions) 
  }
}
