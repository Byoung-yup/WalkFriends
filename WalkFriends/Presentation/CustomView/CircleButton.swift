//
//  CircleButton.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/18.
//

import Foundation
import UIKit

final class CircleButtion: UIButton {
    
    let systemImage: UIImage!
    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//    }
//
    
    init(systemName: String) {
        systemImage = UIImage(systemName: systemName)!
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        
        var btnConfig = UIButton.Configuration.filled()
        btnConfig.baseForegroundColor = .black
        btnConfig.background.backgroundColor = .white
        btnConfig.image = systemImage
//        print("configureUI - frame: \(frame)")
        btnConfig.cornerStyle = .capsule
        btnConfig.preferredSymbolConfigurationForImage = imageConfig
        configuration = btnConfig
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 3)
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("layoutSubviews - frame: \(frame)")
//    }
}
