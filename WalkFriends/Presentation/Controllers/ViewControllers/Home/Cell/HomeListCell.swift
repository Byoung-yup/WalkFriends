////
////  HomeListCell.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/03/23.
////
//
//import UIKit
//import SnapKit
//
//class HomeListCell: UICollectionViewCell {
//    
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    lazy var label: UILabel = {
//       let lbl = UILabel()
//        lbl.contentMode = .center
//        lbl.textColor = .black
//        return lbl
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        configureUI()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        containerView.layer.cornerRadius = 10
//        containerView.layer.borderWidth = 0.5
//        containerView.layer.borderColor = UIColor.blue.cgColor
//    }
//    
//    // MARK: - Configure UI
//    
//    private func configureUI() {
//        
//        addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        containerView.addSubview(label)
//        label.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
//    }
//}
