//
//  Home.swift
//  KTV
//
//  Created by 박성훈 on 8/1/24.
//

import Foundation

struct Home: Decodable {
  let videos: [Video]
  let rankings: [Ranking]
  let recents: [Recent]
  let recommends: [Recommend]
}

extension Home {
  struct Video: Decodable {
    let videoId: Int
    let isHot: Bool
    let title: String
    let subtitle: String
    let imageUrl: URL
    let channel: String
    let channelThumbnailURL: URL
    let channelDescription: String
  }
  
  struct Ranking: Decodable {
    let imageUrl: URL
    let videoId: Int
    
    // Swift Language에 깊이 들어가야 함.
    // 컴파일을 하는 단계에서 빌드를 할 때, 내부적으로 CodingKeys로 생성하고, 이니셜라이저도 CodingKeys 기준으로 생성이 되기 때문에 CodingKey가 아닌 다른 이름으로 하면 호출이 실패할 것임.
    enum CodingKeys: String, CodingKey {  // CodingKeys 라는 이름으로만 해야함
      case imageUrl = "image_Url"
      case videoId
    }
  }
  
  struct Recent: Decodable {
    let imageUrl: URL
    let timeStamp: Double
    let title: String
    let channel: String
  }
  
  struct Recommend: Decodable {
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
    let videoId: Int
  }
}
