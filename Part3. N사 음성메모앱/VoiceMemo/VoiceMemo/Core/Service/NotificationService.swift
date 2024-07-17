//
//  NotificationService.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import UserNotifications

struct NotificationService {
    func sendNotification() {
        // .current() - 공유된 노티피케이션 센터 객체를 반환
        // 앱을 다운받고 첫 시작시에 알림/소리/배지 등의 권한을 묻는 팝업이 requestAuthorization(options: completionHandler:) 메서드
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료!"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request)
            } else {
                //  허용이 안됐다면, 허용할 수 있도록 설정 시스템 내부까지 접근할 수 있도록 고려해보기
            }
        }
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])
    }
}
