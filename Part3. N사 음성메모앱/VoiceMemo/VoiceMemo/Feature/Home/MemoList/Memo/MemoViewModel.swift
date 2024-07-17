//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}
