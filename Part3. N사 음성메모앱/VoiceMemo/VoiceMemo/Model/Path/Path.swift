//
//  Path.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
