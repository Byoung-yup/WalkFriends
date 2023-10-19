//
//  InfoCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/22.
//

import UIKit
import SnapKit
import FirebaseStorageUI

class InfoCell: UITableViewCell {
    
    // MARK: - Utils
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Properties
    
//    var items: Item? {
//        didSet {
//            updateUI()
//        }
//    }
    
    // MARK: - UI Properties
    
    lazy var containerView: MapListDetailView = {
        let view = MapListDetailView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var profile_ImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    
    lazy var nickNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var lineView1: Line = {
        let view = Line()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textAlignment = .center
        lbl.textColor = .systemGray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var memoLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var lineView2: Line = {
        let view = Line()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var regionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "지역 정보"
        return lbl
    }()
    
    lazy var region_ImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
//        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        contentView.backgroundColor = .yellow
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        contentView.addSubview(profile_ImageView)
//        contentView.addSubview(nickNameLabel)
//        contentView.addSubview(lineView1)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(dateLabel)
//        contentView.addSubview(memoLabel)
//        contentView.addSubview(lineView2)
//        contentView.addSubview(regionLabel)
//        contentView.addSubview(region_ImageView)
//
//        profile_ImageView.snp.makeConstraints { make in
//            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.width.height.equalTo(40)
//        }
//
//        nickNameLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(profile_ImageView.snp.centerY)
//            make.left.equalTo(profile_ImageView.safeAreaLayoutGuide.snp.right).offset(20)
//        }
//
//        lineView1.snp.makeConstraints { make in
//            make.top.equalTo(profile_ImageView.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(-14)
//            make.height.equalTo(2)
//        }
//
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineView1.safeAreaLayoutGuide.snp.bottom).offset(20)
////            make.centerX.equalTo(profile_ImageView.snp.centerX)
//                        make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            //            make.right.equalTo(safeAreaLayoutGuide).offset(-14)
//        }
//
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.safeAreaLayoutGuide.snp.bottom).offset(10)
////            make.centerX.equalTo(profile_ImageView.snp.centerX)
//                        make.left.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//
//        memoLabel.snp.makeConstraints { make in
//            make.top.equalTo(dateLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
//        }
//
//        lineView2.snp.makeConstraints { make in
//            make.top.equalTo(memoLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(-14)
//            make.height.equalTo(2)
//        }
//
//        regionLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineView2.safeAreaLayoutGuide.snp.bottom).offset(20)
////            make.centerX.equalTo(profile_ImageView.snp.centerX)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
////            make.right.equalTo(safeAreaLayoutGuide).offset(-14)
//        }
//
//        region_ImageView.snp.makeConstraints { make in
//            make.top.equalTo(regionLabel.safeAreaLayoutGuide.snp.bottom).offset(10)
//            make.left.equalTo(contentView.safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(250)
////            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
//        }
    }
    
//    func updateUI() {
//
//        guard let items = items else { return }
//
//        profile_ImageView.sd_setImage(with: items.userData.reference)
//        nickNameLabel.text = items.userData.profile.nickName
//        titleLabel.text = items.mapData.mapList.title
//        dateLabel.text = items.mapData.mapList.date
//        memoLabel.text = items.mapData.mapList.memo
//        region_ImageView.sd_setImage(with: items.mapData.reference[0])
//    }
    
    
}
