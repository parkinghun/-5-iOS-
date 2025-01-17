//
//  HomeViewModel.swift
//  KTV
//
//  Created by 박성훈 on 11/11/24.
//

import Foundation

@MainActor
final class HomeViewModel {
  private(set) var home: Home?
  let recommendViewModel: HomeRecommendViewModel = .init()
  var dataChanged: (() -> Void)?
  
  func requestData() {
    Task {
      do {
        let home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
        self.home = home
        self.recommendViewModel.recommends = home.recommends
        self.dataChanged?()
      } catch URLError.unsupportedURL {
        print("The URL Provided is invalid")
      } catch let decodingError as DecodingError {
        print("Decoding error occured: ", decodingError)
      } catch {
        print("json parsing failed: \(error.localizedDescription)")
      }
    }
  }
}
