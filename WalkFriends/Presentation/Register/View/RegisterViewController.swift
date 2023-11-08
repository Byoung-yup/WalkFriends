////
////  RegisterViewController.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/02/06.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa
//import RxKeyboard
//
//class RegisterViewController: UIViewController {
//    
//    let registerViewModel: RegisterViewModel
//    
//    let disposeBag = DisposeBag()
//    
//    var responder_TextField: UITextField?
//    
//    // MARK: UI Properties
//    lazy var indicatorView: UIActivityIndicatorView = {
//        let indicatorView = UIActivityIndicatorView(style: .medium)
//        indicatorView.isHidden = true
//       return indicatorView
//    }()
//    
//    lazy var bgImageView: UIImageView = {
//        let imgView = UIImageView()
//        imgView.backgroundColor = .white
//        imgView.contentMode = .scaleAspectFill
//        imgView.image = UIImage(named: "Register_View_Bg")
//        return imgView
//    }()
//    
////    lazy var backToButton: UIButton = {
////        let btn = UIButton()
////        let ImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
////        let systemImage = UIImage(systemName: "arrow.backward", withConfiguration: ImageConfig)
////        btn.setImage(systemImage, for: .normal)
////        btn.tintColor = .systemGray
////        return btn
////    }()
//    
////    lazy var registerLabel: UILabel = {
////        let lbl = UILabel()
////        lbl.text = "Create Account"
////        lbl.textColor = .black
////        lbl.font = UIFont(name: "LettersforLearners", size: 50)
////        return lbl
////    }()
//    
//    lazy var emailTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addleftimage(image: UIImage(systemName: "envelope")!)
//        tf.font = UIFont(name: "LettersforLearners", size: 14)
//        tf.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.textColor = .black
//        tf.autocapitalizationType = .none
//        tf.delegate = self
//        return tf
//    }()
//    
//    lazy var emailSymbol: UIButton = {
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
//        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
//        let btn = UIButton()
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .green
//        btn.isHidden = true
//        return btn
//    }()
//    
//    lazy var passwordTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addleftimage(image: UIImage(systemName: "lock")!)
//        tf.font = UIFont(name: "LettersforLearners", size: 14)
//        tf.attributedPlaceholder = NSAttributedString(string: "패스워드", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.textColor = .black
//        tf.isSecureTextEntry = true
//        tf.autocapitalizationType = .none
//        tf.delegate = self
//        return tf
//    }()
//    
//    lazy var passwordSymbol: UIButton = {
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
//        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
//        let btn = UIButton()
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .green
//        btn.isHidden = true
//        return btn
//    }()
//    
//    lazy var confirmPasswordTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addleftimage(image: UIImage(systemName: "lock")!)
//        tf.font = UIFont(name: "LettersforLearners", size: 14)
//        tf.attributedPlaceholder = NSAttributedString(string: "패스워드 확인", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.textColor = .black
//        tf.isSecureTextEntry = true
//        tf.autocapitalizationType = .none
//        tf.delegate = self
//        return tf
//    }()
//    
//    lazy var confirmPasswordSymbol: UIButton = {
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
//        let systemImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
//        let btn = UIButton()
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .green
//        btn.isHidden = true
//        return btn
//    }()
//    
//    lazy var registerButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("계정 등록", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 14)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = .main_Color
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 25
//        return btn
//    }()
//    
//    lazy var lbl_StackView: UIStackView = {
//       let stackView = UIStackView(arrangedSubviews: [noRegisterLabel, backToLoginButton])
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .white
//        stackView.spacing = 5
//        stackView.distribution = .equalCentering
//        return stackView
//    }()
//    
//    lazy var noRegisterLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "이미 계정이 있으신가요?"
//        lbl.textColor = .gray
//        lbl.font = UIFont(name: "LettersforLearners", size: 14)
//        return lbl
//    }()
//    
//    lazy var backToLoginButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("로그인 하기", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 14)
//        btn.setTitleColor(.main_Color, for: .normal)
//        return btn
//    }()
//    
//    // MARK: - Initialize
//    
//    init(registerViewModel: RegisterViewModel) {
//        self.registerViewModel = registerViewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        print("\(self.description) - deinit")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        
//        
//        configureUI()
//        drawBackground()
//        binding()
//        
////        emailTextField.becomeFirstResponder()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    
//    // MARK: - UI Configure
//    
//    private func configureUI() {
//        
//        view.addSubview(indicatorView)
//        indicatorView.snp.makeConstraints { make in
//            make.width.height.equalTo(100)
//            make.center.equalToSuperview()
//        }
//        
//        view.addSubview(bgImageView)
//        bgImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(75)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-15)
//            make.height.equalTo(200)
//        }
//        
////        view.addSubview(backToButton)
////        backToButton.snp.makeConstraints { make in
////            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
////            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
////        }
//        
//        view.addSubview(emailTextField)
//        emailTextField.snp.makeConstraints { make in
//            make.top.equalTo(bgImageView.safeAreaLayoutGuide.snp.bottom).offset(40)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
//            make.height.equalTo(50)
//        }
//        
//        view.addSubview(passwordTextField)
//        passwordTextField.snp.makeConstraints { make in
//            make.top.equalTo(emailTextField.snp.bottom).offset(30)
//            make.left.equalTo(emailTextField.snp.left)
//            make.right.equalTo(emailTextField.snp.right)
//            make.height.equalTo(50)
//        }
//        
//        view.addSubview(confirmPasswordTextField)
//        confirmPasswordTextField.snp.makeConstraints { make in
//            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
//            make.left.equalTo(emailTextField.snp.left)
//            make.right.equalTo(emailTextField.snp.right)
//            make.height.equalTo(50)
//        }
//        
//        view.addSubview(registerButton)
//        registerButton.snp.makeConstraints { make in
//            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(45)
//            make.left.equalTo(emailTextField.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(emailTextField.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(50)
//        }
//        
//        emailTextField.addSubview(emailSymbol)
//        emailSymbol.snp.makeConstraints { make in
//            make.centerY.equalTo(emailTextField.snp.centerY)
//            make.right.equalTo(emailTextField.safeAreaLayoutGuide.snp.right).offset(-15)
//        }
//        
//        passwordTextField.addSubview(passwordSymbol)
//        passwordSymbol.snp.makeConstraints { make in
//            make.centerY.equalTo(passwordTextField.snp.centerY)
//            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right).offset(-15)
//        }
//        
//        confirmPasswordTextField.addSubview(confirmPasswordSymbol)
//        confirmPasswordSymbol.snp.makeConstraints { make in
//            make.centerY.equalTo(confirmPasswordTextField.snp.centerY)
//            make.right.equalTo(confirmPasswordTextField.safeAreaLayoutGuide.snp.right).offset(-15)
//        }
//        
//        view.addSubview(lbl_StackView)
//        lbl_StackView.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
//            make.centerX.equalToSuperview()
//        }
//        
//        registerButton.addSubview(indicatorView)
//        indicatorView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(30)
//        }
//    }
//    
//    // MARK: - Binding
//    
//    private func binding() {
//        
//        backToLoginButton
//            .rx
//            .tap
//            .asDriver()
//            .drive(onNext: { [weak self] in
//                guard let strongSelf = self else { return }
//                strongSelf.registerViewModel.actions.toBack()
////                    strongSelf.navigationController?.popViewController(animated: true)
//            }).disposed(by: disposeBag)
//        
//        let input = RegisterViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
//                                           password: passwordTextField.rx.text.orEmpty.asObservable(),
//                                           confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
//                                           register: registerButton.rx.tap.asObservable())
//        let output = registerViewModel.transform(input: input)
//        
//        output.isValidEmail
//            .drive(onNext: { [weak self] status in
//                
//                guard let strongSelf = self else { return }
//                
//                strongSelf.emailSymbol.isHidden = !status
//                
//            }).disposed(by: disposeBag)
//        
//        output.isValidPassword
//            .drive(onNext: { [weak self] status in
//                
//                guard let strongSelf = self else { return }
//                
//                strongSelf.passwordSymbol.isHidden = !status
//                
//            }).disposed(by: disposeBag)
//        
//        output.isValidConfirmPassword
//            .drive(onNext: { [weak self] status in
//                
//                guard let strongSelf = self else { return }
//                
//                strongSelf.confirmPasswordSymbol.isHidden = !status
//                
//            }).disposed(by: disposeBag)
//        
//        output.isValidRegister
//            .drive(onNext: { [weak self] status in
//                
//                guard let strongSelf = self else { return }
//                
//                strongSelf.registerButton.isEnabled = status
//                
//            }).disposed(by: disposeBag)
//        
//        output.registerTrigger
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] result in
//                
//                guard let strongSelf = self else { return }
//                
////                strongSelf.indicatorView.startAnimating()
////                strongSelf.indicatorView.isHidden = false
//                
//                switch result {
//                case .success(_):
//                    strongSelf.registerViewModel.actions.toBack()
//                    strongSelf.showFBAuthAlert()
//                    
//                case .failure(let err):
//                    strongSelf.showFBAuthErrorAlert(error: err)
//                }
//                
////                strongSelf.indicatorView.stopAnimating()
////                strongSelf.indicatorView.isHidden = true
//                
//            }).disposed(by: disposeBag)
//        
//        output.isLoding
//            .bind(to: indicatorView.rx.isAnimating)
//            .disposed(by: disposeBag)
//        
//        output.isLoding
//            .asDriver(onErrorJustReturn: false)
//            .drive(onNext: { [weak self] state in
//                print("isLoding: \(state)")
//                if state {
//                    print("true excute")
//                    self?.registerButton.setTitle("", for: .normal)
//                    self?.view.isUserInteractionEnabled = false
//                }
////                else {
////                    print("false excute")
////                    self?.submitBtn.setTitle("공유하기", for: .normal)
////                    self?.view.isUserInteractionEnabled = true
////                }
//                
//            }).disposed(by: disposeBag)
//        
//        RxKeyboard.instance.visibleHeight
//            .skip(1)
//            .drive(onNext: { [weak self] keyboardVisibleHeight in
//                
//                guard let self = self else { return }
//                
//                let password_Height = self.view.frame.height - self.passwordTextField.bounds.origin.y + self.passwordTextField.frame.height + self.view.safeAreaInsets.bottom
//                let confirm_Password_Hegiht = self.view.frame.height - self.confirmPasswordTextField.bounds.origin.y + self.confirmPasswordTextField.frame.height + self.view.safeAreaInsets.bottom
//                
//                var height: CGFloat = CGFloat()
////                print("responder: \(self.responder_TextField)")
////                if keyboardVisibleHeight > 0 {
////                    print("keyboardVisibleHeight > 0 :\(keyboardVisibleHeight)")
////                    if self.responder_TextField == self.passwordTextField {
////                        height = password_Height
////                    }
////                    else if self.responder_TextField == self.confirmPasswordTextField {
////                        height = confirm_Password_Hegiht
////                    }
////
////                    self.view.snp.updateConstraints { make in
////                        make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardVisibleHeight + height)
////                    }
////
////                } else {
////                    print("keyboardVisibleHeight == 0 :\(keyboardVisibleHeight)")
////                    self.view.snp.updateConstraints { make in
////                        make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
////                    }
////                }
//                
//                height = keyboardVisibleHeight > 0 ? -keyboardVisibleHeight + (self.view.frame.height - self.confirmPasswordTextField.frame.origin.y)  : 0
//                
//                self.view.frame.origin.y = height
//                
//                self.view.layoutIfNeeded()
//                
//            }).disposed(by: disposeBag)
//    }
//            
//}
//
//extension RegisterViewController: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        if textField == emailTextField {
//            passwordTextField.becomeFirstResponder()
//            responder_TextField = passwordTextField
//        } else if textField == passwordTextField {
//            confirmPasswordTextField.becomeFirstResponder()
//            responder_TextField = confirmPasswordTextField
//        } else if textField == confirmPasswordTextField {
//            confirmPasswordTextField.resignFirstResponder()
//            responder_TextField = emailTextField
//        }
//        
//        return true
//    }
//}
