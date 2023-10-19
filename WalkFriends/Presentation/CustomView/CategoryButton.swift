//
//  CategoryButton.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/08.
//

import Foundation
import UIKit

class CategoryButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + 25,
                      height: super.intrinsicContentSize.height + 5)
    }
    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame:CGRect.zero)
    }
    
    convenience init(title: String, status: Bool, tagNum: Int) {
        self.init()
        
        setTitle(title, for: .normal)
        tag = tagNum
        if status {
            backgroundColor = .main_Color
            setTitleColor(.white, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        else {
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
