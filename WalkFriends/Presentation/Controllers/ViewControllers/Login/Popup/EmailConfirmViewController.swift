////
////  EmailConfirmViewController.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/02/07.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa
//
//class EmailConfirmViewController: UIViewController {
//    
//    // MARK: - UI Properties
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    lazy var bannerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .orange
//        return view
//    }()
//    
//    lazy var emailTextField: CustomTextField = {
//        let tf = CustomTextField()
//        tf.addLeftPadding()
//        tf.textColor = .black
//        tf.font = UIFont(name: "LettersforLearners", size: 20)
//        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: UIColor.systemGray])
//        tf.autocapitalizationType = .none
//        return tf
//    }()
//    
//    lazy var checkButton: UIButton = {
//        let btn = UIButton(type: .system)
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
//        let systemImage = UIImage(systemName: "paperplane.circle", withConfiguration: imageConfig)
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .orange
//        return btn
//    }()
//    
//    lazy var useEmailButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("사용하기", for: .normal)
//        btn.backgroundColor = .orange
//        btn.setTitleColor(.white, for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.isHidden = true
//        return btn
//    }()
//    
//    lazy var backToButton: UIButton = {
//        let btn = UIButton()
//        let ImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
//        let systemImage = UIImage(systemName: "xmark", withConfiguration: ImageConfig)
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .white
//        return btn
//    }()
//    
//    // MARK: - Properties
//    let emailConfirmViewModel: EmailConfirmViewModel
//    
//    // MARK: - Initialize
//    init(emailConfirmViewModel: EmailConfirmViewModel) {
//        self.emailConfirmViewModel = emailConfirmViewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - viewDidLoad
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .black.withAlphaComponent(0.5)
////        emailTextField.isUserInteractionEnabled = true
//        
//        configureUI()
//        binding()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        emailTextField.becomeFirstResponder()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        containerView.layer.cornerRadius = 20
//        containerView.layer.masksToBounds = true
//        
//        useEmailButton.layer.cornerRadius = 20
//        
//    }
//    
//    // MARK: UI Configure
//    private func configureUI() {
//        
//        view.addSubview(backToButton)
//        backToButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-30)
//        }
//        
//        view.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
//            make.centerY.equalTo(view.snp.centerY)
//            make.height.equalTo(150)
//        }
//        
//        containerView.addSubview(bannerView)
//        bannerView.snp.makeConstraints { make in
//            make.top.equalTo(containerView.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(40)
//        }
//        
//        containerView.addSubview(emailTextField)
//        emailTextField.snp.makeConstraints { make in
//            make.top.equalTo(bannerView.snp.bottom).offset(10)
//            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(15)
//            make.width.equalTo(containerView.snp.width).multipliedBy(0.75)
//            make.height.equalTo(40)
//        }
//        
//        containerView.addSubview(checkButton)
//        checkButton.snp.makeConstraints { make in
//            make.left.equalTo(emailTextField.snp.right).offset(10)
//            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-15)
//            make.centerY.equalTo(emailTextField.snp.centerY)
//        }
//        
//        containerView.addSubview(useEmailButton)
//        useEmailButton.snp.makeConstraints { make in
//            make.top.equalTo(emailTextField.snp.bottom).offset(10)
//            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-10)
//            make.centerX.equalTo(containerView.snp.centerX)
//            make.width.equalTo(containerView.snp.width).dividedBy(3)
//        }
//    }
//    
//    // MARK: - Binding
//    private func binding() {
//        
//        let input = EmailConfirmViewModel.Input(text: emailTextField.rx.text.orEmpty.asDriver(),
//                                                tap: checkButton.rx.tap.asDriver())
//        
//    }
//    
//}
//
