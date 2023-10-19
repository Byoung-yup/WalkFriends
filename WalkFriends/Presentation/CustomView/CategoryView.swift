//
//  File.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/07.
//

import Foundation
import UIKit
import SnapKit

final class CategoryView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    lazy var btn_StackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [category_All_Btn, category_Latest_Btn, category_Popular_Btn, category_Time_Btn])
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var category_All_Btn: UIButton = CategoryButton(title: "전체", status: true, tagNum: 100)
    lazy var category_Latest_Btn: UIButton = CategoryButton(title: "최신", status: false, tagNum: 101)
    lazy var category_Popular_Btn: UIButton = CategoryButton(title: "인기", status: false, tagNum: 102)
    lazy var category_Time_Btn: UIButton = CategoryButton(title: "시간", status: false, tagNum: 103)
    
//    lazy var category_All_Btn: UIButton = {
//        var config = UIButton.Configuration.plain()
//        var titleAttr = AttributedString("전체")
//        titleAttr.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        titleAttr.foregroundColor = .white
//        config.attributedTitle = titleAttr
//        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
//        config.baseBackgroundColor = .main_Color
//        config.baseForegroundColor = .main_Color
//        let btn = UIButton(configuration: config)
////        btn.setTitle("전체", for: .normal)
////        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
////        btn.setTitleColor(.white, for: .normal)
////        btn.backgroundColor = .main_Color
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 100
//        return btn
//    }()
//
//    lazy var category_Latest_Btn: UIButton = {
////        var config = UIButton.Configuration.plain()
////        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
//        let btn = UIButton(type: .system)
//        btn.setTitle("최신", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
////        btn.layer.cornerRadius = 20
////        btn.titleLabel?.adjustsFontSizeToFitWidth = true
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 101
//        return btn
//    }()
//
//    lazy var category_Popular_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("인기순", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
////        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 102
//        return btn
//    }()
//
//    lazy var category_Time_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("시간", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
////        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 103
//        return btn
//    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        category_All_Btn.layer.cornerRadius = category_All_Btn.frame.height / 2
//        category_Latest_Btn.layer.cornerRadius = category_Latest_Btn.frame.height / 2
//        category_Popular_Btn.layer.cornerRadius = category_Popular_Btn.frame.height / 2
//        category_Time_Btn.layer.cornerRadius = category_Time_Btn.frame.height / 2
//    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
//        backgroundColor = .clear
        
        addSubview(btn_StackView)
        btn_StackView.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(21)
//            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-21)
            make.top.bottom.equalToSuperview()
        }
        
//        category_All_Btn.snp.makeConstraints { make in
//            make.top.equalTo(btn_StackView.safeAreaLayoutGuide.snp.top).offset(10)
////            make.bottom.equalTo(btn_StackView.safeAreaLayoutGuide.snp.bottom).offset(-10)
//        }
////
//        category_Latest_Btn.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//        }
//
//        category_Popular_Btn.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//        }
//
//        category_Time_Btn.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//        }
    }
}
