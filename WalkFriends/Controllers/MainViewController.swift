//
//  MainViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import UIKit
import FirebaseAuth

protocol MainViewControllerDelegate {
    func logout()
}

class MainViewController: UIViewController {
    
    var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "메인화면"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logout))
        
    }
    

    @objc private func logout() {
        delegate?.logout()
        try! FirebaseAuth.Auth.auth().signOut()
    }
}
