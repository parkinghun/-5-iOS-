//
//  HomeViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    // 세팅에서 쓰이는 카운트들
    @Published var todosCounot: Int
    @Published var memosCount: Int
    @Published var voiceRecoderCount: Int
    
    init(
        selectedTab: Tab = .voiceRecoder,
        todosCounot: Int = 0,
        memosCount: Int = 0,
        voiceRecoderCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCounot = todosCounot
        self.memosCount = memosCount
        self.voiceRecoderCount = voiceRecoderCount
    }
}

// MARK: - 비지니스 로직
extension HomeViewModel {
    func setTodoCount(_ count: Int) {
        todosCounot = count
    }
    
    func setMemosCount(_ count: Int) {
        memosCount = count
    }
    
    func setVoiceRecoderCount(_ count: Int) {
        voiceRecoderCount = count
    }
    
    // Tab 변경 메서드
    func changeSelectedTab(_ tab: Tab) {
        // 설정에서 이동하기 때문에 요렇게 사용
        selectedTab = tab
    }
}
