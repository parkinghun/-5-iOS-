//
//  OnboardingViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var onBoardingContnts: [OnboardingContent]
    @Published var onBoardingIndex: Int
    
    var isLastOnBoardingItem: Bool {
        onBoardingContnts.count == onBoardingIndex + 1 ? true : false
    }
    
    init(
        onBoardingContnts: [OnboardingContent] = [
            .init(imageFileName: "onboarding_1", title: "오늘의 할 일", subTitle: "To do list로 언제 어디서든 해야할 일을 한눈에"),
            .init(imageFileName: "onboarding_2", title: "똑똑한 나만의 기록장", subTitle: "메모장으로 생각나는 기록은 언제든지"),
            .init(imageFileName: "onboarding_3", title: "하나라도 놓치지 않도록", subTitle: "음성메모 기능으로 놓치고 싶지않은 기록까지"),
            .init(imageFileName: "onboarding_4", title: "정확한 시간의 경과", subTitle: "타이머 기능으로 원하는 시간으로 확인")
        ],
        onBoadingIndex: Int = 0
    ) {
        self.onBoardingContnts = onBoardingContnts
        self.onBoardingIndex = onBoadingIndex
    }
    
    func nextBtnTapped(action: () -> Void) {
        if onBoardingContnts.count > (onBoardingIndex + 1){
            onBoardingIndex += 1
        } else {
            action()
        }
    }
}
