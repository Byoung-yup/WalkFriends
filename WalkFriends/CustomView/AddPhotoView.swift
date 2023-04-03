//
//  AddPhotoView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/03.
//

import UIKit

class AddPhotoView: UIView {
    
    lazy var scrollView: UIScrollView = {
       let view = UIScrollView()
    
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
