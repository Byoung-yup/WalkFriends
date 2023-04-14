//
//  MapListViewCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import UIKit
import SnapKit

class MapListViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Initailize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        
        
    }
}
