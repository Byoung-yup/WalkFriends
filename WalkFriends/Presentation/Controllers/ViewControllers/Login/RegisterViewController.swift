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
import RxGesture

class RegisterViewController: UIViewController {
    
    let registerViewModel: RegiterViewModel
    
    let disposebag = DisposeBag()
    
    // MARK: UI Properties
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
    
    lazy var emailTextView: CustomLabelView = {
        let lbl = CustomLabelView()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [.systemGray])
        imageAttachment.image = UIImage(systemName: "envelope", withConfiguration: imageConfig)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " Email"))
        lbl.attributedText = attributedString
        lbl.textColor = .systemGray
        lbl.font = UIFont(name: "LettersforLearners", size: 20)
        lbl.isUserInteractionEnabled = true
        return lbl
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
    
    // MARK: UI Configure
    private func configureUI() {
        
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
        
        view.addSubview(emailTextView)
        emailTextView.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(40)
            make.left.equalTo(registerLabel.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextView.snp.bottom).offset(20)
            make.left.equalTo(emailTextView.snp.left)
            make.right.equalTo(emailTextView.snp.right)
            make.height.equalTo(50)
        }
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.equalTo(emailTextView.snp.left)
            make.right.equalTo(emailTextView.snp.right)
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
        
        emailTextView.addSubview(emailSymbol)
        emailSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextView.snp.centerY)
            make.right.equalTo(emailTextView.safeAreaLayoutGuide.snp.right).offset(-15)
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
    
    // MARK: Binding
    private func binding() {
        
        let input = RegiterViewModel.Input(emailConfirm: emailTextView.rx.tapGesture().when(.recognized).asObservable(),
                                           back: backToButton.rx.tap.asDriver())
        let output = registerViewModel.transform(input: input)
        
        output.dismiss
            .drive()
            .disposed(by: disposebag)
    }

                

    // MARK: Alert Method
    private func showAlert() {
        let alert = UIAlertController(title: "안내", message: "올바른 이메일 형식이 아닙니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: false)
    }
}
