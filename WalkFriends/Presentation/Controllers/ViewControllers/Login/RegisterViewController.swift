//
//  RegisterViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    let registerViewModel: RegiterViewModel
    
    let disposebag = DisposeBag()
    
    // MARK: UI Properties
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.isHidden = true
       return indicatorView
    }()
    
    lazy var backToButton: UIButton = {
        let btn = UIButton()
        let ImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let systemImage = UIImage(systemName: "arrow.backward", withConfiguration: ImageConfig)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .systemGray
        return btn
    }()
    
    lazy var registerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create Account"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 50)
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
    
    lazy var emailSymbol: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        let btn = UIButton()
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .green
        btn.isHidden = true
        return btn
    }()
    
    lazy var passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "lock")!)
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var passwordSymbol: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        let btn = UIButton()
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .green
        btn.isHidden = true
        return btn
    }()
    
    lazy var confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.addleftimage(image: UIImage(systemName: "lock")!)
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var confirmPasswordSymbol: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        let btn = UIButton()
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .green
        btn.isHidden = true
        return btn
    }()
    
    lazy var registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 25)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .orange
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    lazy var noRegisterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Already have a account?"
        lbl.textColor = .gray
        lbl.font = UIFont(name: "LettersforLearners", size: 19)
        return lbl
    }()
    
    lazy var backToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 19)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    // MARK: - Initialize
    
    init(registerViewModel: RegiterViewModel) {
        self.registerViewModel = registerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        binding()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Configure
    
    private func configureUI() {
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        view.addSubview(backToButton)
        backToButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
        }
        
        view.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(backToButton.snp.bottom).offset(80)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(40)
            make.left.equalTo(registerLabel.snp.left)
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
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.equalTo(emailTextField.snp.left)
            make.right.equalTo(emailTextField.snp.right)
            make.height.equalTo(50)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
            make.right.equalTo(confirmPasswordTextField.snp.right)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(noRegisterLabel)
        noRegisterLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX).offset(-20)
        }
        
        view.addSubview(backToLoginButton)
        backToLoginButton.snp.makeConstraints { make in
            make.centerY.equalTo(noRegisterLabel.snp.centerY)
            make.left.equalTo(noRegisterLabel.snp.right).offset(5)
        }
        
        emailTextField.addSubview(emailSymbol)
        emailSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField.snp.centerY)
            make.right.equalTo(emailTextField.safeAreaLayoutGuide.snp.right).offset(-15)
        }
        
        passwordTextField.addSubview(passwordSymbol)
        passwordSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right).offset(-15)
        }
        
        confirmPasswordTextField.addSubview(confirmPasswordSymbol)
        confirmPasswordSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(confirmPasswordTextField.snp.centerY)
            make.right.equalTo(confirmPasswordTextField.safeAreaLayoutGuide.snp.right).offset(-15)
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = RegiterViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
                                           password: passwordTextField.rx.text.orEmpty.asObservable(),
                                           confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
                                           register: registerButton.rx.tap.asObservable(),
                                           naviback: backToButton.rx.tap.asObservable(),
                                           toBack: backToLoginButton.rx.tap.asObservable())
        let output = registerViewModel.transform(input: input)
        
        output.isValidEmail
            .drive(onNext: { [weak self] status in
                
                guard let strongSelf = self else { return }
                
                strongSelf.emailSymbol.isHidden = !status
                
            }).disposed(by: disposebag)
        
        output.isValidPassword
            .drive(onNext: { [weak self] status in
                
                guard let strongSelf = self else { return }
                
                strongSelf.passwordSymbol.isHidden = !status
                
            }).disposed(by: disposebag)
        
        output.isValidConfirmPassword
            .drive(onNext: { [weak self] status in
                
                guard let strongSelf = self else { return }
                
                strongSelf.confirmPasswordSymbol.isHidden = !status
                
            }).disposed(by: disposebag)
        
        output.isValidRegister
            .drive(onNext: { [weak self] status in
                
                guard let strongSelf = self else { return }
                
                strongSelf.registerButton.isEnabled = status
                
            }).disposed(by: disposebag)
        
        output.dismiss
            .subscribe()
            .disposed(by: disposebag)
        
        output.registerTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
//                strongSelf.indicatorView.startAnimating()
                strongSelf.indicatorView.isHidden = false
                
                switch result {
                case .success(_):
                    strongSelf.registerViewModel.actionDelegate?.toBack()
                    strongSelf.showFBAuthAlert()
                    
                case .failure(let err):
                    strongSelf.showFBAuthErrorAlert(error: err)
                }
                
//                strongSelf.indicatorView.stopAnimating()
//                strongSelf.indicatorView.isHidden = true
                
            }).disposed(by: disposebag)
    }
            
}
