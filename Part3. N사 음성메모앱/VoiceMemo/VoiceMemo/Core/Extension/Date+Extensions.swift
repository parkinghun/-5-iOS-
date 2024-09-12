//
//  Date+Extensions.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

extension Date {
    
    /// Date를 가지고 오전/오후 시간:분 형식으로 String으로 반환
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"  // 오전/오후 시간:분
        return formatter.string(from: self)
    }
    
    
    /// List에 있는 Date가 오늘이면 "오늘" 아니면 "M월 d일 E요일"을 String으로 반환
    var formattedDay: String {
        let now = Date()  // 현재 날짜와 시간을 알 수 있음
        let calendar = Calendar.current  // 현재 사용하고 있는 달력을 확인할 수 있음

        let nowStartOfDay = calendar.startOfDay(for: now)  // 현재
        let dateStartOfDay = calendar.startOfDay(for: self)  // 작성한 날짜
        let numOfDaysDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!

        if numOfDaysDifference == 0 {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
        
        // 이 코드가 더 짧을듯
//        if calendar.isDateInToday(self) {
//            return "오늘"
//        } else {
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "ko_KR")
//            formatter.dateFormat = "M월 d일 E요일"
//            return formatter.string(from: self)
//        }
    }
    
    /// ex - 2022.07.14
    var formattedVoiceRecoderTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
}
