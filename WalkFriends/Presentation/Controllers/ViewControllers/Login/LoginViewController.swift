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
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginViewModel: LoginViewModel
    
    let disposeBag = DisposeBag()
    
    var handle: AuthStateDidChangeListenerHandle!
    
    // MARK: - UI Properties
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()
    
    lazy var loginLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Walk Friends"
        lbl.textColor = .black
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
    
    lazy var forget_Password_Btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 13)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그인", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00)
        btn.layer.cornerRadius = 25
        btn.isEnabled = false
        return btn
    }()
    
    lazy var lineView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "Line")
        return imgView
    }()
    
    lazy var btn_StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [google_Sign_Btn, facebook_Sign_Btn, kakao_Sign_Btn])
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var google_Sign_Btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Google"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        //        btn.layer.shadowRadius = 6
        return btn
    }()
    
    lazy var facebook_Sign_Btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Facebook"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        //        btn.layer.shadowRadius = 10
        return btn
    }()
    
    lazy var kakao_Sign_Btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Kakao"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        //        btn.layer.shadowRadius = 6
        return btn
    }()
    
    lazy var lbl_StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [registerInfoLabel, registerInfoButton])
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var registerInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "계정이 없으신가요?"
        lbl.textColor = .gray
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        return lbl
    }()
    
    lazy var registerInfoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("계정 만들기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 14)
        btn.setTitleColor(.main_Color, for: .normal)
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
        
        configureUI()
        drawBackground()
        binding()
        
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            
            if let user = user {
                print("email: \(user.providerData[0].email!)")
                print("uid: \(user.providerData[0].uid)")
                print("---------------------------------------------")
                if let currentUser = auth.currentUser {
                    print("email: \(currentUser.email)")
                    print("uid: \(currentUser.uid)")
                }
                print("Firebase")
                print("currentUser: \(FirebaseService.shard.auth.currentUser!)")
                print("currentUser email: \(FirebaseService.shard.auth.currentUser!.email)")
                print("currentUser uid: \(FirebaseService.shard.auth.currentUser!.uid)")
                self?.loginViewModel.isLoginState.accept(true)
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Configure
    
    private func configureUI() {
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat(UIScreen.main.bounds.width) / 4)
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
        
        view.addSubview(forget_Password_Btn)
        forget_Password_Btn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.safeAreaLayoutGuide.snp.bottom).offset(5)
            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.safeAreaLayoutGuide.snp.bottom).offset(60)
            make.left.equalTo(passwordTextField.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(emailTextField.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(emailTextField.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(20)
        }
        
        view.addSubview(btn_StackView)
        btn_StackView.snp.makeConstraints { make in
            make.top.equalTo(lineView.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(62)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-62)
            make.height.equalTo(50)
        }
        
        //        view.addSubview(google_Sign_Btn)
        //        google_Sign_Btn.snp.makeConstraints { make in
        //            make.top.equalTo(loginButton.safeAreaLayoutGuide.snp.bottom).offset(50)
        //            make.centerX.equalToSuperview()
        //            make.width.equalTo(80)
        //        }
        //
        //        view.addSubview(facebook_Sign_Btn)
        //        facebook_Sign_Btn.snp.makeConstraints { make in
        //            make.top.equalTo(loginButton.safeAreaLayoutGuide.snp.bottom).offset(50)
        //            make.centerX.equalToSuperview()
        //            make.width.equalTo(80)
        //        }
        
        //        view.addSubview(registerInfoLabel)
        //        registerInfoLabel.snp.makeConstraints { make in
        //            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        //            make.centerX.equalTo(view.snp.centerX).offset(-20)
        //        }
        //
        //        view.addSubview(registerInfoButton)
        //        registerInfoButton.snp.makeConstraints { make in
        //            make.centerY.equalTo(registerInfoLabel.snp.centerY)
        //            make.left.equalTo(registerInfoLabel.snp.right).offset(5)
        //        }
        
        view.addSubview(lbl_StackView)
        lbl_StackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        registerInfoButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.loginViewModel.actions.showRegisterViewController()
            }).disposed(by: disposeBag)
        
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
                                         password: passwordTextField.rx.text.orEmpty.asObservable(),
                                         login: loginButton.rx.tap.asObservable(),
                                         google_SignIn: google_Sign_Btn.rx.tap.asObservable(),
                                         facebook_SignIn: facebook_Sign_Btn.rx.tap.asObservable(),
                                         kakak_SignIn: kakao_Sign_Btn.rx.tap.asObservable())
        let output = loginViewModel.transform(input: input)
        
        output.loginEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.loginTrigger
//            .observe(on: MainScheduler.instance)
            .debug()
            .subscribe(onNext: { [weak self] result in
                print("로그인 에러: \(result)")
//                guard let strongSelf = self else { return }
//
//                switch result {
//                case .success(_):
//                    strongSelf.loginViewModel.actions.signIn()
//                case .failure(let err):
//                    strongSelf.showFBAuthErrorAlert(error: err)
//                }
                
            }).disposed(by: disposeBag)
        
        output.isLoginState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                
                if state { self?.loginViewModel.actions.signIn() }
                
            }).disposed(by: disposeBag)
        
        output.signIn
            .debug()
            .catchAndReturn(false)
            .subscribe(onNext: { result in
                print("로그인 상태: \(result)")
            }).disposed(by: disposeBag)
            
        
        //        output.loginTrigger_Google
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] result in
        //
        //                guard let strongSelf = self else { return }
        //
        //                switch result {
        //                case .success(_):
        //                    break
        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
        //                case .failure(let err):
        //                    strongSelf.showFBAuthErrorAlert(error: err)
        //                }
        //
        //            }).disposed(by: disposeBag)
        //
        //        output.loginTrigger_Facebook
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] result in
        //
        //                guard let strongSelf = self else { return }
        //
        //                switch result {
        //                case .success(_):
        //                    break
        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
        //                case .failure(let err):
        //                    strongSelf.showFBAuthErrorAlert(error: err)
        //                }
        //
        //            }).disposed(by: disposeBag)
        //
        //        output.loginTrigger_Kakao
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] result in
        //
        //
        //                guard let strongSelf = self else { return }
        //
        //                switch result {
        //                case .success(_):
        //                    break
        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
        //                case .failure(let err):
        //                    strongSelf.showFBAuthErrorAlert(error: err)
        //                }
        //
        //            })
        //            .disposed(by: disposeBag)
    }
    
}
