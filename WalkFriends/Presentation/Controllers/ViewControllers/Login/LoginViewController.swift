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

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginViewModel: LoginViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    lazy var loginLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Walk Friends"
        let length = lbl.text!.count
        let attribtuedString = NSMutableAttributedString(string: lbl.text ?? "")
        let range = (lbl.text! as NSString).range(of: "Friends")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00), range: range)
        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 100)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.attributedText = attribtuedString
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var emailTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "envelope")!)
        tf.font = UIFont(name: "LettersforLearners", size: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var passwordTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "lock")!)
        tf.font = UIFont(name: "LettersforLearners", size: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "패스워드", attributes: [.foregroundColor: UIColor.systemGray])
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
        btn.layer.cornerRadius = 25
        btn.isEnabled = false
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
    
    deinit {
        print("LoginViewController - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
//        configureUI()
        binding()
        print(UIScreen.main.bounds)
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
        drawBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Configure
    
    private func configureUI() {
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat(UIScreen.main.bounds.width) / 3)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.width.equalTo(loginLabel.snp.width)
            make.centerX.equalToSuperview()
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

    // MARK: - Binding
    
    private func binding() {
        
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
                                         password: passwordTextField.rx.text.orEmpty.asObservable(),
                                         login: loginButton.rx.tap.asObservable(),
                                         register: registerInfoButton.rx.tap.asObservable())
        let output = loginViewModel.transform(input: input)
        
        output.loginEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
            
        output.present
            .subscribe()
            .disposed(by: disposeBag)
        
        output.loginTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(_):
                    strongSelf.loginViewModel.actionDelegate?.signIn()
                case .failure(let err):
                    strongSelf.showFBAuthErrorAlert(error: err)
                }
                
            }).disposed(by: disposeBag)
    }
    
}
