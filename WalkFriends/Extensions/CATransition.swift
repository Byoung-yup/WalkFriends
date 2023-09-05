//
//  CATransition.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/08/28.
//

import Foundation
import UIKit

extension CATransition {
    
    func segueFromBottom() -> CATransition {
        duration = 0.375
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = .moveIn
        subtype = .fromTop
        return self
    }
    
    func segueFromTop() -> CATransition {
        duration = 0.375
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = .moveIn
        subtype = .fromBottom
        return self
    }
}
