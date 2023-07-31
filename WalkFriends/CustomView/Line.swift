//
//  Line.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/31.
//

import Foundation
import UIKit

class Line: UIView {
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        let centerY = frame.height / 2
        aPath.move(to: CGPoint(x: 0, y: centerY))
        aPath.addLine(to: CGPoint(x: frame.width, y: centerY))
        aPath.close()
        UIColor.lightGray.set()
        aPath.lineWidth = 1
        aPath.stroke()
    }
}
