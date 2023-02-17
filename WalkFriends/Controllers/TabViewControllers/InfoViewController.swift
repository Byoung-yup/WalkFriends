//
//  InfoViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit

protocol InfoViewControllerDelegate {
    func logout()
}

class InfoViewController: UIViewController {
    
    var infoDelegate: InfoViewControllerDelegate!
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그아웃", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "내 정보"
        
        ConfigureUI()
        addTarget()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.orange.cgColor
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
    }
    
    // MARK: Configure UI
    private func ConfigureUI() {
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    // MARK: addTarget
    private func addTarget() {
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    // MARK: objc Method
    @objc private func logout() {
        
        FirebaseService.shard.logout { [weak self] result in
            guard let strongSelf = self else { return }
            if result { strongSelf.infoDelegate.logout() }
            else { }
        }
    }
}
