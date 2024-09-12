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

/*
    네비게이션 Path
    - Onboarding -> HomeView(Tab에서 이동)
    - todo
    - memo(isCreateMode: Bool, memo: Memo?) -> 해당 값을 받아서 생성뷰/편집뷰 나눠서 좀
 */
