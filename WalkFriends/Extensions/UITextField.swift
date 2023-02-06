//
//  UITextField.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import Foundation
import UIKit

extension UITextField {
        
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addleftimage(image: UIImage) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + 20, height: image.size.height))
        let leftimage = UIImageView(frame: CGRect(x: 15, y: 0, width: image.size.height, height: image.size.height))
        
        containerView.addSubview(leftimage)
        
        leftimage.image = image
        leftimage.contentMode = .scaleAspectFill
        leftimage.tintColor = .gray
        
        self.leftView = containerView
        self.leftViewMode = .always
    }
    
}
