//
//  HomeViewModel.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import Foundation

@MainActor
final class HomeViewModel {
  private(set) var home: Home?
  var dataChanged: (() -> Void)?
  
  func requestData() {
    // 번들 내부에 앱에 있는 리소스에 접근 -> home.json의 URL을 변수에 할당
//    guard let jsonUrl = Bundle.main.url(forResource: "home", withExtension: "json") else {
//      print("resource not found")
//      return
//    }
//    
//    let jsonDecoder = JSONDecoder()
//    do {
//      let data = try Data(contentsOf: jsonUrl)  // jsonUrl로부터 데이터를 가져와서
//      let home = try jsonDecoder.decode(Home.self, from: data)  // Home타입에 맞게 data를 decode 함
//      self.home = home
//      self.dataChanged?()
//    } catch {
//      print("json parsing failed: \(error.localizedDescription)")
//    }
    
    
    Task {
      do {
        self.home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
        self.dataChanged?()
      } catch {
        print("json parsing failed: \(error.localizedDescription)")
      }
    }
  }
}
