//
//  UIImageView+Task.swift
//  KTV
//
//  Created by 박성훈 on 8/1/24.
//

import UIKit

extension UIImageView {
  // 이미지 받아오기
  func loadImage(url: URL) -> Task<Void, Never> {
    return .init {
      guard let responseData = try? await URLSession.shared.data(for: .init(url: url)).0,
            let image = UIImage(data: responseData)
      else {
        return
      }
      
      self.image = image
    }
  }
}
