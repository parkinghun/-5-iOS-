//
//  PathType.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreateMode: Bool, memo: Memo?)  // 열거형의 associatedValue
}
