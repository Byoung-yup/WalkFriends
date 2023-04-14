//
//  Date.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation

extension Date {
    
    func getCurrenTime() -> String {
        
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy-MM-dd"
        
        return date.string(from: self)
    }
}
