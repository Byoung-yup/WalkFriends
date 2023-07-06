//
//  Int.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/06.
//

import Foundation

extension Int {
    
    func numberFormatter() -> String {
        let num = String(Double(self / 1000))
        return num + "K"
    }
}
