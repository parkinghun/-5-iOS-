//
//  Todo.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool  // 완료되었는지
    
    var convertedDayAndTime: String {  // 오늘 - 오후 03:00에 알림
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
