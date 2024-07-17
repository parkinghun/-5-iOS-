//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation
import UIKit

final class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    var norificationService: NotificationService
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: Time = .init(hours: 0, minutes: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false,
        norificationService: NotificationService = .init()
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.norificationService = norificationService
    }
}

// 비지니스 로직
extension TimerViewModel {
    func settingBtnTapped() {
        isDisplaySetTimeView = false
        timeRemaining = time.convertedSeconds
        
        // TODO: - 타이머 시작 메서드 호출!
        startTimer()
    }
    
    func cancelBtnTapped() {
        // TODO: - 타이머 종료 메서드 호출
        stopTimer()
        
        isDisplaySetTimeView = true
    }
    
    func pauseOrRestartBtnTapped() {
        if isPaused {
            // TODO: - 타이머 시작 메서드 호출
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        
        isPaused.toggle()
    }
}

private extension TimerViewModel {
    func startTimer() {
        guard timer == nil else { return }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier?  // 백그라운드 작업 id를 저장하기 위한 변수
        
        // task 메서드는 앱이 백그라운드로 전환됐을 때 일부 작업을 계속 수행할 수 있게 하는 메서드
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            if let task = backgroundTaskID {  
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    // TODO: - 타이머 종류 메서드 호출
                    self.stopTimer()  // 캡처 클로저 -> self 
                    // TODO: - Local Notification
                    self.norificationService.sendNotification()  // 이렇게만 하면 foreground에서는 noti가 오는데 background에서는 noti가 안감..
                    
                    if let task = backgroundTaskID {
                        UIApplication.shared.endBackgroundTask(task)
                        backgroundTaskID = .invalid
                    }
                }
            }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func setLocalNotification() {
        
    }
}
