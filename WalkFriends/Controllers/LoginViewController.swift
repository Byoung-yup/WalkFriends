//
//  LoginViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate {
    func showRegisterVC()
    func signIn()
}

class LoginViewController: UIViewController {
    
    let loginViewModel: LoginViewModel
    
    let disposeBag = DisposeBag()
    
    var delegate: LoginViewControllerDelegate!
    
    // MARK: UI Properties
    lazy var loginLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Login"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 50)
        return lbl
    }()
    
    lazy var loginInfoLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Please sign in to continue."
        lbl.textColor = .gray
        lbl.font = UIFont(name: "LettersforLearners", size: 27)
        return lbl
    }()
    
    lazy var emailTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "envelope")!)
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var passwordTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "lock")!)
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor.systemGray])
        tf.isSecureTextEntry = true
        tf.textColor = .black
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 25)
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
        lbl.font = UIFont(name: "LettersforLearners", size: 19)
        return lbl
    }()
    
    lazy var registerInfoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 19)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureUI()
        addTarget()
        Binding()
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        loginButton.addTarget(self, action: #selector(loginButtonBinding), for: .touchUpInside)
    }
    
    // MARK: Binding
    private func Binding() {
        
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.password).disposed(by: disposeBag)
        
        loginViewModel.isValidInput.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    // MARK: objc Method
    @objc private func showRegisterVC() {
        delegate.showRegisterVC()
    }
    
    // MARK: loginButton Binding
    @objc private func loginButtonBinding() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginViewModel.signIn(with: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                print("email: \(email)")
                if result {
                    self.delegate.signIn()
                } else {
                    // 로그인 오류 안내 메시지
                }
            }.disposed(by: disposeBag)
        
    }
    
}

