//
//  MapListViewCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import UIKit
import SnapKit

class MapListViewCell: UITableViewCell {
    
    // MARK: - UI Properties

    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 25)
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        return lbl
    }()
    
    // MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var mapList: MapList? = nil {
        didSet {
            configureCell()
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.cornerRadius = 10
        
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(10)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func configureCell() {
        
        titleLabel.text = mapList?.title
        dateLabel.text = mapList?.date
    }
}
