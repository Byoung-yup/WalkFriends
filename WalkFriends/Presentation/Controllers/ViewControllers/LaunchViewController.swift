////
////  LaunchViewController.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/07/03.
////
//
//import Foundation
//import UIKit
//import SnapKit
//
//class LaunchViewController: UIViewController {
//
//    lazy var bgImageView: UIImageView = {
//       let imgView = UIImageView()
//        imgView.backgroundColor = .white
//        imgView.contentMode = .scaleAspectFill
//        imgView.image = UIImage(named: "Launch_View_Bg")
//        return imgView
//    }()
//
//    lazy var mainLbl1: UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .black
//        lbl.contentMode = .center
//        lbl.numberOfLines = 1
//        lbl.text = "Together"
//        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 22)
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//
//    lazy var mainLbl2: UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .black
//        lbl.contentMode = .center
//        lbl.numberOfLines = 1
//        lbl.text = "with WalkFriends"
//        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 22)
//        lbl.adjustsFontSizeToFitWidth = true
//        return lbl
//    }()
//
//    lazy var startButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("워크프렌즈 시작하기", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00)
//        btn.layer.cornerRadius = 25
//        return btn
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//
//        configureUI()
//        drawBackground()
//    }
//
//    // MARK: - Configure UI
//
//    private func configureUI() {
//
//        view.addSubview(bgImageView)
//        bgImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(45)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-15)
//            make.height.equalTo(430)
//        }
//
//        view.addSubview(mainLbl1)
//        mainLbl1.snp.makeConstraints { make in
//            make.top.equalTo(bgImageView.safeAreaLayoutGuide.snp.bottom).offset(35)
//            make.centerX.equalToSuperview()
//        }
//
//        view.addSubview(mainLbl2)
//        mainLbl2.snp.makeConstraints { make in
//            make.top.equalTo(mainLbl1.safeAreaLayoutGuide.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//        }
//
//        view.addSubview(startButton)
//        startButton.snp.makeConstraints { make in
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(30)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-30)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
//            make.height.equalTo(50)
//        }
//    }
//}
