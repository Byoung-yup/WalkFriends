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
import RxKeyboard
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginViewModel: LoginViewModel
    
    let disposeBag = DisposeBag()
    
//    var handle: AuthStateDidChangeListenerHandle!
    
    var limitTime: Int = 300 // 5분
    
    var keyboardHeight: CGFloat!
    
    // MARK: - UI Properties
    
    lazy var back_Btn: UIButton = {
//        var config = UIButton.Configuration.plain()
//        config.baseForegroundColor = .clear
//        config.image = UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: safeArea.top, width: view.frame.size.width, height: naviBarHeight))
        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
        return bar
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .gray
        view.backgroundColor = .clear
        view.hidesWhenStopped = true
        return view
    }()
    
//    lazy var loginLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "Walk Friends"
//        lbl.textColor = .black
//        let length = lbl.text!.count
//        let attribtuedString = NSMutableAttributedString(string: lbl.text ?? "")
//        let range = (lbl.text! as NSString).range(of: "Friends")
//        attribtuedString.addAttribute(.foregroundColor, value: UIColor.main_Color, range: range)
//        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 100)
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.attributedText = attribtuedString
//        lbl.textAlignment = .center
//        return lbl
//    }()
    
    lazy var login_Label: UILabel = {
        let lbl = UILabel()
        lbl.text = "안녕하세요!\n휴대폰 번호로 가입해주세요."
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var sub_Login_Label: UILabel = {
        let lbl = UILabel()
        lbl.text = "휴대폰 번호는 안전하게 보관되어 타인에게 공개되지 않아요."
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var phoneNumber_TextField: UITextField = {
        let tf = UITextField()
        tf.addLeftPadding()
        tf.attributedPlaceholder = NSAttributedString(string: "휴대폰 번호(- 없이 숫자만 입력)", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1.0
        return tf
    }()
    
    lazy var certification_Btn: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.baseBackgroundColor = .main_Color
//        config.cornerStyle = .dynamic
//        var titleAttr = AttributedString(stringLiteral: "인증문자 받기")
//        titleAttr.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        titleAttr.foregroundColor = .white
//        config.attributedTitle = titleAttr
        
        let btn = UIButton(type: .system)
        btn.setTitle("인증문자 받기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 5
//        btn.isEnabled = false
        return btn
    }()
    
    lazy var certificationNumber_TextField: UITextField = {
        let tf = UITextField()
        tf.addLeftPadding()
        tf.attributedPlaceholder = NSAttributedString(string: "인증번호 입력", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1.0
        return tf
    }()
    
    lazy var certification_Info_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "어떤 경우에도 타인에게 공유하지 마세요!"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var start_Btn: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.baseBackgroundColor = .main_Color
//        config.cornerStyle = .dynamic
//        var titleAttr = AttributedString(stringLiteral: "시작하기")
//        titleAttr.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        titleAttr.foregroundColor = .white
//        config.attributedTitle = titleAttr
        
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        return btn
    }()
    
//    lazy var emailTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addleftimage(image: UIImage(systemName: "envelope")!)
//        tf.font = UIFont(name: "LettersforLearners", size: 15)
//        tf.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.textColor = .black
//        tf.autocapitalizationType = .none
//        return tf
//    }()
//
//    lazy var passwordTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addleftimage(image: UIImage(systemName: "lock")!)
//        tf.font = UIFont(name: "LettersforLearners", size: 15)
//        tf.attributedPlaceholder = NSAttributedString(string: "패스워드", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.isSecureTextEntry = true
//        tf.textColor = .black
//        tf.autocapitalizationType = .none
//        return tf
//    }()
    
//    lazy var forget_Password_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("비밀번호를 잊으셨나요?", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 13)
//        btn.setTitleColor(.black, for: .normal)
//        return btn
//    }()
    
//    lazy var loginButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("로그인", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00)
//        btn.layer.cornerRadius = 25
//        btn.isEnabled = false
//        return btn
//    }()
    
//    lazy var lineView: UIImageView = {
//        let imgView = UIImageView()
//        imgView.backgroundColor = .white
//        imgView.contentMode = .scaleAspectFill
//        imgView.image = UIImage(named: "Line")
//        return imgView
//    }()
//
//    lazy var btn_StackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [google_Sign_Btn, facebook_Sign_Btn, kakao_Sign_Btn])
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .white
//        stackView.spacing = 20
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//
//    lazy var google_Sign_Btn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "Google"), for: .normal)
//        btn.contentVerticalAlignment = .center
//        btn.contentHorizontalAlignment = .center
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 10
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.4
//        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
//        //        btn.layer.shadowRadius = 6
//        return btn
//    }()
//
//    lazy var facebook_Sign_Btn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "Facebook"), for: .normal)
//        btn.contentVerticalAlignment = .center
//        btn.contentHorizontalAlignment = .center
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 10
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.4
//        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
//        //        btn.layer.shadowRadius = 10
//        return btn
//    }()
//
//    lazy var kakao_Sign_Btn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "Kakao"), for: .normal)
//        btn.contentVerticalAlignment = .center
//        btn.contentHorizontalAlignment = .center
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 10
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.4
//        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
//        //        btn.layer.shadowRadius = 6
//        return btn
//    }()
//
//    lazy var lbl_StackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [registerInfoLabel, registerInfoButton])
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .white
//        stackView.spacing = 5
//        stackView.distribution = .equalCentering
//        return stackView
//    }()
//
//    lazy var registerInfoLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "계정이 없으신가요?"
//        lbl.textColor = .gray
//        lbl.font = UIFont(name: "LettersforLearners", size: 14)
//        return lbl
//    }()
//
//    lazy var registerInfoButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("계정 만들기", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 14)
//        btn.setTitleColor(.main_Color, for: .normal)
//        return btn
//    }()
    
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
//        set_Delegate()
        binding()
//        indicatorView.startAnimating()
        
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        handle = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
//
//            if let user = user {
//                print("email: \(user.providerData[0].email!)")
//                print("uid: \(user.providerData[0].uid)")
//                print("---------------------------------------------")
//                if let currentUser = auth.currentUser {
//                    print("email: \(currentUser.email)")
//                    print("uid: \(currentUser.uid)")
//                }
//                print("Firebase")
//                print("currentUser: \(FirebaseService.shard.auth.currentUser!)")
//                print("currentUser email: \(FirebaseService.shard.auth.currentUser!.email)")
//                print("currentUser uid: \(FirebaseService.shard.auth.currentUser!.uid)")
////                self?.loginViewModel.isLoginState.accept(true)
//            }
//        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    // MARK: - UI Configure
    
    private func configureUI() {
        
        drawBackground()
        setNaviBar()
        
        view.addSubview(login_Label)
        view.addSubview(sub_Login_Label)
        view.addSubview(phoneNumber_TextField)
        view.addSubview(certification_Btn)
        view.addSubview(indicatorView)
        
        
        login_Label.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        sub_Login_Label.snp.makeConstraints { make in
            make.top.equalTo(login_Label.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
        }
        
        phoneNumber_TextField.snp.makeConstraints { make in
            make.top.equalTo(sub_Login_Label.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(45)
        }
        
        certification_Btn.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber_TextField.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(45)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
//        view.addSubview(loginLabel)
//        loginLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat(UIScreen.main.bounds.width) / 4)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
//        }
//
//        view.addSubview(emailTextField)
//        emailTextField.snp.makeConstraints { make in
//            make.top.equalTo(loginLabel.safeAreaLayoutGuide.snp.bottom).offset(40)
//            make.width.equalTo(loginLabel.snp.width)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(50)
//        }
//
//        view.addSubview(passwordTextField)
//        passwordTextField.snp.makeConstraints { make in
//            make.top.equalTo(emailTextField.snp.bottom).offset(20)
//            make.left.equalTo(emailTextField.snp.left)
//            make.right.equalTo(emailTextField.snp.right)
//            make.height.equalTo(50)
//        }
//
//        view.addSubview(forget_Password_Btn)
//        forget_Password_Btn.snp.makeConstraints { make in
//            make.top.equalTo(passwordTextField.safeAreaLayoutGuide.snp.bottom).offset(5)
//            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right)
//        }
//
//        view.addSubview(loginButton)
//        loginButton.snp.makeConstraints { make in
//            make.top.equalTo(passwordTextField.safeAreaLayoutGuide.snp.bottom).offset(60)
//            make.left.equalTo(passwordTextField.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(passwordTextField.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(50)
//        }
//
//        view.addSubview(lineView)
//        lineView.snp.makeConstraints { make in
//            make.top.equalTo(loginButton.safeAreaLayoutGuide.snp.bottom).offset(40)
//            make.left.equalTo(emailTextField.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(emailTextField.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(20)
//        }
//
//        view.addSubview(btn_StackView)
//        btn_StackView.snp.makeConstraints { make in
//            make.top.equalTo(lineView.safeAreaLayoutGuide.snp.bottom).offset(40)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(62)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-62)
//            make.height.equalTo(50)
//        }
        
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
        
//        view.addSubview(lbl_StackView)
//        lbl_StackView.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
//            make.centerX.equalToSuperview()
//        }
    }
    
    private func setNaviBar() {
        
        let naviItem = UINavigationItem()
        let left_EmptyView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: naviBarHeight))
        let left_Item = UIBarButtonItem(customView: left_EmptyView)
        let left_CustomView = UIBarButtonItem(customView: back_Btn)
        
        naviItem.leftBarButtonItems = [left_Item, left_CustomView]
        
        navigationBar.setItems([naviItem], animated: false)
        
        view.addSubview(navigationBar)
    }
    
    // MARK: - Set Delegate
    
//    private func set_Delegate() {
//        phoneNumber_TextField.delegate = self
//    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = LoginViewModel.Input(phoneNumber: phoneNumber_TextField.rx.text.orEmpty.filter { $0.count <= 13                                                 }.asObservable(),
                                         authenticationNumber: certificationNumber_TextField.rx.text.orEmpty.asObservable(),
                                         certification_Trigger: certification_Btn.rx.tap.asObservable(),
                                         start_Trigger: start_Btn.rx.tap.asObservable(),
                                         toBack_Trigger: back_Btn.rx.tap.asObservable())
        let output = loginViewModel.transform(input: input)
        
        output.certification
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                print("status: \(status)")
                guard let self = self else { return }
                
                switch status {
                case .success(_):
                    Toast.show("인증번호가 문자로 전송됐습니다. (최대 20초 소요)", keyboardHeight: self.keyboardHeight + self.view.safeAreaInsets.bottom)
                case .failure(let err):
                    var text: String!
                    
                    switch err {
                    case .CaptchaCheckFailed:
                        text = "인증 토큰이 만료 되었습니다."
                    case .QuotaExceeded:
                        text = "인증 요청 할당량이 초과되었습니다."
                    case .InvalidPhoneNumber:
                        text = "유효하지 않는 전화번호 입니다."
                    case .MissingPhoneNumber:
                        text = "전화번호가 제공되지 않았습니다."
                    default:
                        break
                    }
                    Toast.show(text, keyboardHeight: self.keyboardHeight + self.view.safeAreaInsets.bottom)
                }
            }).disposed(by: disposeBag)
        
        output.start
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                
                switch status {
                case .success(let bool):
                    if bool {
                        self?.loginViewModel.actions.dismiss(true)
                    } else {
                        self?.loginViewModel.actions.dismiss(false)
                    }
                case .failure(let err):
                    self?.loginViewModel.actions.dismiss(nil)
                    self?.showAlert(error: err)
                }
            }).disposed(by: disposeBag)
        
        output.toBack
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.loginViewModel.actions.dismiss(nil)
            }).disposed(by: disposeBag)
        
        loginViewModel.isLoading
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        phoneNumber_TextField
            .rx
            .controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] in

                guard let self = self, let text = self.phoneNumber_TextField.text else { return }
                let formattedText = self.format(phoneNumber: text)
//                print("formattedText: \(formattedText)")
                self.phoneNumber_TextField.text = formattedText
            }).disposed(by: disposeBag)
        

//
        phoneNumber_TextField
            .rx
            .text.orEmpty
            .subscribe(onNext: { [weak self] str in
//                print("str: \(str)")
//                print("count: \(str.count)")
                guard let self = self else { return }
                
                if str.count == 13 {
                    self.certification_Btn.isEnabled = true
                    self.certification_Btn.backgroundColor = .main_Color
                } else {
                    self.certification_Btn.isEnabled = false
                    self.certification_Btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
                }
            }).disposed(by: disposeBag)

        certification_Btn
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.updateUI()
            }).disposed(by: disposeBag)
        
        certificationNumber_TextField
            .rx
            .text.orEmpty
            .subscribe(onNext: { [weak self] str in
                
                guard let self = self else { return }
                
                if str.count == 6 {
                    self.start_Btn.isEnabled = true
                    self.start_Btn.backgroundColor = .main_Color
                } else {
                    self.start_Btn.isEnabled = false
                    self.start_Btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
                }
                
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
//                print("height: \(height)")
                self?.keyboardHeight = height
            }).disposed(by: disposeBag)
        
//        certificationNumber_TextField
//            .rx
//            .controlEvent(.editingDidBegin)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.phoneNumber_TextField.layer.borderColor = UIColor.main_Color.cgColor
//            }).disposed(by: disposeBag)
//
//        certificationNumber_TextField
//            .rx
//            .controlEvent(.editingDidEnd)
//            .subscribe(onNext: { [weak self] in
//                self?.phoneNumber_TextField.layer.borderColor = UIColor.gray.cgColor
//            }).disposed(by: disposeBag)
        
//        registerInfoButton
//            .rx
//            .tap
//            .asDriver()
//            .drive(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.loginViewModel.actions.showRegisterViewController()
//            }).disposed(by: disposeBag)
//        
//        forget_Password_Btn
//            .rx
//            .tap
//            .asDriver()
//            .drive(onNext: { [weak self] in 
//                guard let self = self else { return }
//                self.loginViewModel.actions.showResetViewController()
//            }).disposed(by: disposeBag)
//        
//        
//        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
//                                         password: passwordTextField.rx.text.orEmpty.asObservable(),
//                                         login: loginButton.rx.tap.asObservable(),
//                                         google_SignIn: google_Sign_Btn.rx.tap.asObservable(),
//                                         facebook_SignIn: facebook_Sign_Btn.rx.tap.asObservable(),
//                                         kakak_SignIn: kakao_Sign_Btn.rx.tap.asObservable())
//        let output = loginViewModel.transform(input: input)
//        
//        output.loginEnabled
//            .asDriver(onErrorJustReturn: false)
//            .drive(loginButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
//        output.loginTrigger
////            .observe(on: MainScheduler.instance)
//            .debug()
//            .subscribe(onNext: { [weak self] result in
//                print("로그인 에러: \(result)")
////                guard let strongSelf = self else { return }
////
////                switch result {
////                case .success(_):
////                    strongSelf.loginViewModel.actions.signIn()
////                case .failure(let err):
////                    strongSelf.showFBAuthErrorAlert(error: err)
////                }
//                
//            }).disposed(by: disposeBag)
//        
//        output.isLoginState
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] state in
//                
//                if state { self?.loginViewModel.actions.signIn() }
//                
//            }).disposed(by: disposeBag)
//        
//        output.signIn
//            .debug()
//            .catchAndReturn(false)
//            .subscribe(onNext: { result in
//                print("로그인 상태: \(result)")
//            }).disposed(by: disposeBag)
//            
//        
//        //        output.loginTrigger_Google
//        //            .observe(on: MainScheduler.instance)
//        //            .subscribe(onNext: { [weak self] result in
//        //
//        //                guard let strongSelf = self else { return }
//        //
//        //                switch result {
//        //                case .success(_):
//        //                    break
//        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
//        //                case .failure(let err):
//        //                    strongSelf.showFBAuthErrorAlert(error: err)
//        //                }
//        //
//        //            }).disposed(by: disposeBag)
//        //
//        //        output.loginTrigger_Facebook
//        //            .observe(on: MainScheduler.instance)
//        //            .subscribe(onNext: { [weak self] result in
//        //
//        //                guard let strongSelf = self else { return }
//        //
//        //                switch result {
//        //                case .success(_):
//        //                    break
//        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
//        //                case .failure(let err):
//        //                    strongSelf.showFBAuthErrorAlert(error: err)
//        //                }
//        //
//        //            }).disposed(by: disposeBag)
//        //
//        //        output.loginTrigger_Kakao
//        //            .observe(on: MainScheduler.instance)
//        //            .subscribe(onNext: { [weak self] result in
//        //
//        //
//        //                guard let strongSelf = self else { return }
//        //
//        //                switch result {
//        //                case .success(_):
//        //                    break
//        ////                    strongSelf.loginViewModel.actionDelegate?.signIn()
//        //                case .failure(let err):
//        //                    strongSelf.showFBAuthErrorAlert(error: err)
//        //                }
//        //
//        //            })
//        //            .disposed(by: disposeBag)
    }
    
}

// MARK: - Certification

extension LoginViewController {
    
    private func updateUI() {
        
        view.addSubview(certificationNumber_TextField)
        view.addSubview(certification_Info_Lbl)
        view.addSubview(start_Btn)
        
        login_Label.isHidden = true
        sub_Login_Label.isHidden = true
        
        phoneNumber_TextField.resignFirstResponder()
        phoneNumber_TextField.isUserInteractionEnabled = false
        phoneNumber_TextField.layer.borderColor = UIColor.gray.cgColor
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            
            self.phoneNumber_TextField.snp.remakeConstraints { make in
                make.top.equalTo(self.navigationBar.safeAreaLayoutGuide.snp.bottom).offset(15)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(21)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-21)
                make.height.equalTo(45)
            }
            
            self.certificationNumber_TextField.snp.makeConstraints { make in
                make.top.equalTo(self.certification_Btn.safeAreaLayoutGuide.snp.bottom).offset(15)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(21)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-21)
                make.height.equalTo(45)
            }
            
            self.certification_Info_Lbl.snp.makeConstraints { make in
                make.top.equalTo(self.certificationNumber_TextField.safeAreaLayoutGuide.snp.bottom).offset(15)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(21)
            }
            
            self.start_Btn.snp.makeConstraints { make in
                make.top.equalTo(self.certification_Info_Lbl.safeAreaLayoutGuide.snp.bottom).offset(15)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(21)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-21)
                make.height.equalTo(45)
            }
            
            self.view.layoutIfNeeded()
            
        } completion: { [weak self] _ in
            
            guard let self = self else { return }
            
//            Toast.show("인증번호가 문자로 전송됐습니다.", keyboardHeight: self.keyboardHeight + self.view.safeAreaInsets.bottom)
            
            self.certification_Btn.isEnabled = false
            self.certification_Btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
            
            self.certificationNumber_TextField.becomeFirstResponder()
            self.certificationNumber_TextField.layer.borderColor = UIColor.main_Color.cgColor
            
            self.getsetTime()
        }
  
    }
}

// MARK: - Timer

extension LoginViewController {
    
    @objc private func getsetTime() {
        secToTime(sec: limitTime)
        
        if limitTime == -1 { limitTime = 300 }
    }
    
    private func secToTime(sec: Int) {
        
        limitTime -= 1
        
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            let title = "인증문자 재요청 (\(String(minute))분 0\(String(second))초)"
            certification_Btn.setTitle(title, for: .normal)
        } else {
            let title = "인증문자 재요청 (\(String(minute))분 \(String(second))초)"
            certification_Btn.setTitle(title, for: .normal)
        }
        
        if limitTime != 0 {
            perform(#selector(getsetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            certification_Btn.setTitle("인증문자 받기", for: .normal)
            certification_Btn.backgroundColor = .main_Color
            certification_Btn.isEnabled = true
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

//        if let text = textField.text, let range = Range(range, in: text) {
//            let newText = text.replacingCharacters(in: range, with: string)
//            return newText.count <= 11 // 휴대폰 번호 최대 길이 제한
//        }
//        return true
            
        
//        guard let text = textField.text else { return false }
//        print("text: \(text)")
//        let newString = (text as NSString).replacingCharacters(in: range, with: string)
//        print("range: \(range)")
//        print("string: \(string)")
//        print("newString: \(newString)")
//        textField.text = newString
//        textField.text = format(with: "XXX XXXX XXXX", phone: newString)

//        if newString.count >= 13 {
//            certification_Btn.isEnabled = true
//            certification_Btn.backgroundColor = .main_Color
//        } else {
//            certification_Btn.isEnabled = false
//            certification_Btn.backgroundColor = .main_Color.withAlphaComponent(0.3)
//        }
//        return true
        
//        if textField == phoneNumber_TextField {
//
//            guard let text = textField.text else {
//                return false
//            }
//
////            let characterSet = CharacterSet(charactersIn: string)
////            if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
////                return false
////            }
//
//            let formatter = DefaultTextInputFormatter(textPattern: "### #### ####")
//            let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
//            textField.text = result.formattedText
//            let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
//            textField.selectedTextRange = textField.textRange(from: position, to: position)
//            return false
//        }
//
//        return false
//    }
}

// MARK: - Format

extension LoginViewController {
    
    func format(phoneNumber: String) -> String {
        let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX XXXX XXXX" // 휴대전화 번호 포맷을 지정합니다.
        var result = ""
        var index = cleanedPhoneNumber.startIndex
//        print("startIndex: \(cleanedPhoneNumber.startIndex)")
//        print("endIndex: \(cleanedPhoneNumber.endIndex)")
        for character in mask where index < cleanedPhoneNumber.endIndex {
            if character == "X" {
                result.append(cleanedPhoneNumber[index])
                index = cleanedPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
//        print("result: \(result)")
        return result
    }
}
