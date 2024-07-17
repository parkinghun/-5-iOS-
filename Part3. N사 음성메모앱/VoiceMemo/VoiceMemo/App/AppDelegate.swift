//
//  AppDelegate.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import UIKit

// 앱에 대한 설정
final class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UNUserNotificationCenter.current().delegate = notificationDelegate
            return true
    }
}
