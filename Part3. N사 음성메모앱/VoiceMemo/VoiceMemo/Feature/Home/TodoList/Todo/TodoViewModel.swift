//
//  TodoViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isDisplayCalendar: Bool
    
    init(
        title: String = "",
        time: Date = Date(),
        day: Date = Date(),
        isDisplayCalendar: Bool = false
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isDisplayCalendar = isDisplayCalendar
    }
}

extension TodoViewModel {
    func setIsDisplayCalendar(_ isDisplay: Bool) {
        isDisplayCalendar = isDisplay
    }
}
