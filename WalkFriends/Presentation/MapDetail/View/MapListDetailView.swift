////
////  MapListDetailView.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/09/25.
////
//
//import Foundation
//import UIKit
//import SnapKit
//import FirebaseStorageUI
//
//final class MapListDetailView: UIView {
//    
//    // MARK: - Properties
//    
//    var items: Item? {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    // MARK: - UI Properties
//    
//    lazy var titleLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.numberOfLines = 0
//        lbl.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        lbl.textAlignment = .left
//        lbl.textColor = .black
//        return lbl
//    }()
//    
//    lazy var dateLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.numberOfLines = 1
//        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        lbl.textAlignment = .center
//        lbl.textColor = .systemGray
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//    
//    lazy var lineView1: Line = {
//        let view = Line()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    lazy var profile_ImageView: UIImageView = {
//        let imageV = UIImageView()
//        imageV.contentMode = .scaleAspectFill
//        return imageV
//    }()
//    
//    lazy var nickNameLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.numberOfLines = 1
//        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        lbl.textAlignment = .center
//        lbl.textColor = .black
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//    
//    lazy var lineView2: Line = {
//        let view = Line()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    lazy var memoLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.numberOfLines = 0
//        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        lbl.textAlignment = .left
//        lbl.textColor = .black
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//    
//    lazy var lineView3: Line = {
//        let view = Line()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    lazy var regionLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.numberOfLines = 1
//        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        lbl.textAlignment = .center
//        lbl.textColor = .black
//        lbl.text = "지역 정보"
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//    
//    lazy var region_ImageView: UIImageView = {
//        let imageV = UIImageView()
//        imageV.contentMode = .scaleAspectFill
//        return imageV
//    }()
//    
//    
//    // MARK: - Init
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecycle
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        profile_ImageView.layer.cornerRadius = profile_ImageView.frame.height / 2
//        profile_ImageView.clipsToBounds = true
//        
//        region_ImageView.layer.cornerRadius = 15
//        region_ImageView.clipsToBounds = true
//    }
//    
//    // MARK: - Configure UI
//    
//    private func configureUI() {
//        
//        addSubview(titleLabel)
//        addSubview(dateLabel)
//        addSubview(lineView1)
//        addSubview(profile_ImageView)
//        addSubview(nickNameLabel)
//        addSubview(lineView2)
//        addSubview(memoLabel)
//        addSubview(lineView3)
//        addSubview(regionLabel)
//        addSubview(region_ImageView)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
//        }
//        
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.safeAreaLayoutGuide.snp.bottom).offset(5)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//        
//        lineView1.snp.makeConstraints { make in
//            make.top.equalTo(dateLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(2)
//        }
//        
//        profile_ImageView.snp.makeConstraints { make in
//            make.top.equalTo(lineView1.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.width.height.equalTo(40)
//        }
//        
//        nickNameLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(profile_ImageView.snp.centerY)
//            make.left.equalTo(profile_ImageView.safeAreaLayoutGuide.snp.right).offset(10)
//        }
//        
//        lineView2.snp.makeConstraints { make in
//            make.top.equalTo(profile_ImageView.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(2)
//        }
//        
//        memoLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineView2.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//        
//        lineView3.snp.makeConstraints { make in
//            make.top.equalTo(memoLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(2)
//        }
//        
//        regionLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineView3.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//        
//        region_ImageView.snp.makeConstraints { make in
//            make.top.equalTo(regionLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(20)
//            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(200)
//            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
//        }
//        
//    }
//    
//    private func updateUI() {
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
//}
