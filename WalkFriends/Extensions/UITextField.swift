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
    
//    func formatPhoneNumber(range: NSRange, string: String) {
//        guard let text = self.text else {
//            return
//        }
//        let characterSet = CharacterSet(charactersIn: string)
//        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
//            return
//        }
//
//        let newLength = text.count + string.count - range.length
//        let formatter: DefaultTextInputFormatter
//        let onlyPhoneNumber = text.filter { $0.isNumber }
//
//        let currentText: String
//        if newLength < 13 {
//            if text.count == 13, string.isEmpty { // crash 방지
//                formatter = DefaultTextInputFormatter(textPattern: "### #### ####")
//            } else {
//                formatter = DefaultTextInputFormatter(textPattern: "### ### ####")
//            }
//        } else {
//            formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
//        }
//
//        currentText = formatter.format(onlyPhoneNumber) ?? ""
//        let result = formatter.formatInput(currentText: currentText, range: range, replacementString: string)
//        if text.count == 13, string.isEmpty {
//            self.text = DefaultTextInputFormatter(textPattern: "###-###-####").format(result.formattedText.filter { $0.isNumber })
//        } else {
//            self.text = result.formattedText
//        }
//
//        let position: UITextPosition
//        if self.text?.substring(from: result.caretBeginOffset - 1, to: result.caretBeginOffset - 1) == "-" {
//            position = self.position(from: self.beginningOfDocument, offset: result.caretBeginOffset + 1)!
//        } else {
//            position = self.position(from: self.beginningOfDocument, offset: result.caretBeginOffset)!
//        }
//
//        self.selectedTextRange = self.textRange(from: position, to: position)
//    }
    
}
