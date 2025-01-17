//
//  DataLoader.swift
//  KTV
//
//  Created by 박성훈 on 11/11/24.
//

import Foundation

struct DataLoader {
  private static let session: URLSession = .shared
  
  static func load<T: Decodable>(url: String, for type: T.Type) async throws -> T {
    guard let url = URL(string: url) else {
      throw URLError(.unsupportedURL)
    }
    
    let data = try await Self.session.data(for: .init(url: url)).0

    let jsonDecoder = JSONDecoder()
    return try jsonDecoder.decode(T.self, from: data)
  }
}
