//
//  DBError.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import Foundation

enum DBError: Error {
  case error(Error)
  case emptyValue
  case invalidatedType
}
