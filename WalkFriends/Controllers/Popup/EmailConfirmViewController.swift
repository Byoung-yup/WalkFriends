//
//  EmailConfirmViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol submitEmailDelegate {
    func submitEmail(with email: String, exists: Bool)
}

enum emailExists {
    case exists, nonExists
}

class EmailConfirmViewController: UIViewController {
    
    let emailConfirmViewModel: EmailConfirmViewModel
    
    let disposeBag = DisposeBag()
    
    var delegate: submitEmailDelegate!
    
    // MARK: UI Properties
    lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bannerView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var emailTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.addLeftPadding()
        tf.textColor = .black
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: UIColor.systemGray])
        return tf
    }()
    
    lazy var checkButton: UIButton = {
        let btn = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let systemImage = UIImage(systemName: "paperplane.circle", withConfiguration: imageConfig)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .orange
        return btn
    }()
    
    lazy var useEmailButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("사용하기", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.isHidden = true
        return btn
    }()
    
    lazy var backToButton: UIButton = {
        let btn = UIButton()
        let ImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let systemImage = UIImage(systemName: "xmark", withConfiguration: ImageConfig)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    // MARK: - Initialize
    init(viewModel: EmailConfirmViewModel) {
        emailConfirmViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        configureUI()
        binding()
        addTarget()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        useEmailButton.layer.cornerRadius = 20
    
    }
    
    // MARK: UI Configure
    private func configureUI() {
        
        view.addSubview(backToButton)
        backToButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-30)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(150)
        }
        
        containerView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(15)
            make.width.equalTo(containerView.snp.width).multipliedBy(0.75)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.left.equalTo(emailTextField.snp.right).offset(10)
            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-15)
            make.centerY.equalTo(emailTextField.snp.centerY)
        }
        
        containerView.addSubview(useEmailButton)
        useEmailButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalTo(containerView.snp.centerX)
            make.width.equalTo(containerView.snp.width).dividedBy(3)
        }
    }
    
    // MARK: - Binding
    private func binding() {
        
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: emailConfirmViewModel.email).disposed(by: disposeBag)
        
        emailConfirmViewModel.isValidEmail.bind(to: checkButton.rx.isEnabled).disposed(by: disposeBag)
        
        checkButton.rx.controlEvent(.touchDown)
            .subscribe { _ in
                
                guard let emailText = self.emailTextField.text else { return }
                self.checkEmail(with: emailText)
                
            }.disposed(by: disposeBag)
    }
    
    // MARK: addTarget
    private func addTarget() {
        useEmailButton.addTarget(self, action: #selector(submitEmail), for: .touchUpInside)
        backToButton.addTarget(self, action: #selector(toBack), for: .touchUpInside)
    }
    
    // MARK: objc Method
    @objc private func submitEmail() {
        
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            
            guard let emailText = self.emailTextField.text else { return }
            self.delegate.submitEmail(with: emailText, exists: true)
        }
        
    }
    
    @objc private func toBack() {
        dismiss(animated: false)
    }
    
    // MARK: checkEmail
    private func checkEmail(with email: String) {
        
        emailConfirmViewModel.userExists(with: email)
            .observe(on: MainScheduler.instance)
            .subscribe { exists in
                
                if exists {
                    self.existingAlert(type: .exists)
                    self.useEmailButton.isHidden = true
                } else {
                    self.existingAlert(type: .nonExists)
                    self.useEmailButton.isHidden = false
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: Alert Method
    private func existingAlert(type: emailExists) {
        
        let alert: UIAlertController
        
        switch type {
        case .nonExists:
            alert = UIAlertController(title: "안내", message: "사용 가능합니다.", preferredStyle: .alert)
        case .exists:
            alert = UIAlertController(title: "안내", message: "존재하는 이메일 입니다.", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: false)
    }
}

