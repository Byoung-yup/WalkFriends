//
//  String.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidName() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[가-힣]{2,4}", options: .caseInsensitive)
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Za-z0-9!_@$%^&+=]{8,20}", options: .caseInsensitive)
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
}
