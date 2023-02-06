//
//  LoginViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import UIKit
import SnapKit

protocol showRegisterVCDelegate {
    func showRegisterVC()
}

class LoginViewController: UIViewController {
    
    var delegate: showRegisterVCDelegate!
    
    // MARK: UI Properties
    lazy var loginLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Login"
        lbl.tintColor = .black
        lbl.font = UIFont(name: "Lemon-Days", size: 40)
        return lbl
    }()
    
    lazy var loginInfoLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Please sign in to continue."
        lbl.textColor = .gray
        lbl.font = UIFont(name: "Lemon-Days", size: 17)
        return lbl
    }()
    
    lazy var emailTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.backgroundColor = .white
        tf.addleftimage(image: UIImage(systemName: "envelope")!)
        tf.font = UIFont(name: "Lemon-Days", size: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "Email")
        return tf
    }()
    
    lazy var passwordTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "lock")!)
        tf.font = UIFont(name: "Lemon-Days", size: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Lemon-Days", size: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .orange
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    lazy var registerInfoLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Don't have an account?"
        lbl.textColor = .gray
        lbl.font = UIFont(name: "Lemon-Days", size: 12)
        return lbl
    }()
    
    lazy var registerInfoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Lemon-Days", size: 12)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureUI()
        addTarget()
    }
    
    // MARK: UI Configure
    private func configureUI() {
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
        }
        
        view.addSubview(loginInfoLabel)
        loginInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(15)
            make.left.equalTo(loginLabel.snp.left)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).offset(-60)
            make.left.equalTo(loginLabel.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.equalTo(emailTextField.snp.left)
            make.right.equalTo(emailTextField.snp.right)
            make.height.equalTo(50)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.right.equalTo(passwordTextField.snp.right)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(registerInfoLabel)
        registerInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX).offset(-20)
        }
        
        view.addSubview(registerInfoButton)
        registerInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(registerInfoLabel.snp.centerY)
            make.left.equalTo(registerInfoLabel.snp.right).offset(5)
        }
    }
    
    private func addTarget() {
        
        registerInfoButton.addTarget(self, action: #selector(showRegisterVC), for: .touchUpInside)
        
    }
    
    // MARK: objc Method
    @objc private func showRegisterVC() {
        delegate.showRegisterVC()
    }
    
}
