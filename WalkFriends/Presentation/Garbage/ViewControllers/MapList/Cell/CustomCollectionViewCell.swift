//
//  CustomCollectionViewCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/12.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
