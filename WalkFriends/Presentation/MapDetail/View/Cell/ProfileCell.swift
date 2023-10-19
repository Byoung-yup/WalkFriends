////
////  ProfileCell.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/09/26.
////
//
//import UIKit
//import SnapKit
//import FirebaseStorageUI
//
//class ProfileCell: UITableViewCell {
//
//    // MARK: - Utils
//    
//    static var identifier: String {
//        return String(describing: self)
//    }
//    
//    // MARK: - Properties
//    
//    var userData: FinalUserProfile? {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    // MARK: - UI Properties
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
//    // MARK: - Init
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been impl")
//    }
//    
//    // MARK: - Configure
//    
//    private func configureUI() {
//        backgroundColor = .white
//        
//        addSubview(profile_ImageView)
//        addSubview(nickNameLabel)
//        
//        profile_ImageView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(20)
//            make.left.equalTo(safeAreaLayoutGuide).offset(14)
//            make.width.height.equalTo(30)
//        }
//        
//        nickNameLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(profile_ImageView.snp.centerY)
//            make.left.equalTo(profile_ImageView.safeAreaLayoutGuide.snp.right).offset(10)
//        }
//        
//    }
//    
//    private func updateUI() {
//        
//        guard let userData = userData else { return }
//        
//        profile_ImageView.sd_setImage(with: userData.reference)
//        nickNameLabel.text = userData.profile.nickName
//    }
//}
