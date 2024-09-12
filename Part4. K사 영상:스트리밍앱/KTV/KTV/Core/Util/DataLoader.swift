//
//  DataLoader.swift
//  KTV
//
//  Created by 박성훈 on 8/1/24.
//

import Foundation

struct DataLoader {
  private static let session: URLSession = .shared
  
  static func load<T: Decodable>(url: String, for type: T.Type) async throws -> T {
    guard let url = URL(string: url) else {
      throw URLError(.unsupportedURL)
    }
    
    // 서버 콜을 해서 받아오도록 함 
    let data = try await Self.session.data(for: .init(url: url)).0
    let jsonDecoder = JSONDecoder()
    
    return try jsonDecoder.decode(T.self, from: data)
  }
}
