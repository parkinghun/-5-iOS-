//
//  URLImageView.swift
//  LMessanger
//
//  Created by 박성훈 on 1/7/25.
//

import SwiftUI


struct URLImageView: View {
  @EnvironmentObject var container: DIContainer
  
  let urlString: String?
  let placeholderName: String
  
  init(urlString: String?, placeholderName: String? = nil) {
    self.urlString = urlString
    self.placeholderName = placeholderName ?? "placeholder"
  }
  
  var body: some View {
    if let urlString, !urlString.isEmpty {
      URLInnerImageView(
        viewModel: .init(container: container, urlString: urlString),
        placeholderName: placeholderName
      )
      .id(urlString)
      // id modifier 추가,
      // 이너뷰 url이 변경되었을 시 내부 stateObject를 변경해주기 위해 명시적인 id 추가
    } else {
      Image(placeholderName)
        .resizable()
    }
  }
}

fileprivate struct URLInnerImageView: View {
  // 호출할 때마다 뷰모델을 세팅하는 과정이 번거로울 수 있기 때문에 이미지뷰를 감싸는 이너뷰를 만듦
  @StateObject var viewModel: URLImageViewModel
  
  let placeholderName: String
  var placeholderImage: UIImage {
    UIImage(named: placeholderName) ?? UIImage()
  }
  
  var body: some View {
    Image(uiImage: viewModel.loadedImage ?? placeholderImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .onAppear {
        // 캐시에서 가져오는 작업
        if !viewModel.loadingOrSuccess {
          viewModel.start()
        }
      }
  }
}

#Preview {
  URLImageView(urlString: nil)
    .environmentObject(DIContainer(services: StubService()))
}
