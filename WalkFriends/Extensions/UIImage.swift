//
//  UIImage.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
import UIKit

extension UIImage {
    
    func convertJPEGData() -> Data {
        var data = Data()
        data = self.jpegData(compressionQuality: 0.7)!
        return data
    }
}
