//
//  HomeViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    lazy var profileView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        profileView.layer.cornerRadius = 20
        
        profileView.layer.shadowColor = UIColor.gray.cgColor
        profileView.layer.shadowRadius = 20
        profileView.layer.shadowOffset = CGSize(width: 0, height: 10)
        profileView.layer.shadowOpacity = 0.5
//        view.layer.masksToBounds = true
    }
    
    // MARK: Configure UI
    private func configureUI() {
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(200)
        }
        
    }
}
