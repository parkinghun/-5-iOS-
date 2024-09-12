//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    // 앱 구조체가 UIKit의 기능이나 low-level의 iOS 시스템 이벤트를 처리해야 할 때 사용
    // SwiftUI에서 UIKit AppDelegate를 사용하는 프로퍼티 래퍼임
    // SwiftUI의 라이프사이클을 사용하는 앱에서 앱 델리게이트 콜백을 처리하려면 UIApplicationDelegate 프로토콜을 준수해야함, 필요한 메서드를 구현해야 함.
    
    // SwiftUI는 델리게이트를 인스턴스화 하고, 생명주기 이벤트가 발생할 때마다 응답해서 델리게이트 메서드를 호출한다.
    // 앱 선언부에서만 정의하고, 꼭 한번만 선언해야함(여러번 선언하면 런타임 에러가 발생함)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
