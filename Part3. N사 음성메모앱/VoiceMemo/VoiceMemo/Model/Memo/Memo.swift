//
//  Memo.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

struct Memo: Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var date: Date
    
    var convertedDate: String {
        return String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
