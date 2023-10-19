//
//  LocationListCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/06.
//

import UIKit
import SnapKit

class LocationListCell: UITableViewCell {

    // MARK: - Utils
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Properties
    
    lazy var location_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.backgroundColor = .clear
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // MARK: - Initailize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        backgroundColor = .clear
        
        contentView.addSubview(location_Lbl)
        location_Lbl.snp.makeConstraints { make in
            make.top.left.equalTo(safeAreaLayoutGuide)
        }
    }
}
