//
//  CustomView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/18.
//

import UIKit

class CustomLabelView: UILabel {
    
    lazy var innerShadow: CALayer = {
        let innerShadow = CALayer()
        layer.addSublayer(innerShadow)
        return innerShadow
    }()
    
    private var padding = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }
    
    func applyDesign() {
        innerShadow.frame = bounds
        
        // Shadow path (1pt ring around bounds)
        let radius = self.frame.size.height/2
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy:-1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
        
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor.darkGray.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 2)
        innerShadow.shadowOpacity = 0.5
        innerShadow.shadowRadius = 2
        innerShadow.cornerRadius = self.frame.size.height/2
        
    }
}
