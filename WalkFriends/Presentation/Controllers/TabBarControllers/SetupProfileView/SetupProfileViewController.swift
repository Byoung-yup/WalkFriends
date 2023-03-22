//
//  SetupProfileViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SetupProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
//    lazy var scrollView: UIScrollView = {
//       let scrollView = UIScrollView()
//        scrollView.backgroundColor = .white
//        scrollView.isScrollEnabled = true
//        return scrollView
//    }()
    
//    lazy var contentView: UIStackView = {
//        let contentView = UIStackView()
//        contentView.axis = .vertical
//        contentView.backgroundColor = .systemGray5
//        return contentView
//    }()
    
    lazy var setupUserView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var setupPetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var userNicknameTextField: CustomTextField = {
       let tf = CustomTextField()
        tf.textColor = .black
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [.foregroundColor: UIColor.systemGray])
        return tf
    }()
    
    lazy var userGenderSgControl: UISegmentedControl = {
        let items = ["남", "여"]
        let sg = UISegmentedControl(items: items)
        sg.backgroundColor = .white
        return sg
    }()
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        let defaultImage = UIImage(systemName: "person.circle", withConfiguration: config)
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.image = defaultImage
        return imageV
    }()
    
//    lazy var petNameTextField: CustomTextField = {
//       let tf = CustomTextField()
//        tf.textColor = .black
//        tf.font = UIFont(name: "LettersforLearners", size: 20)
//        tf.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [.foregroundColor: UIColor.systemGray])
//        return tf
//    }()
//
//    lazy var petAgeTextField: CustomTextField = {
//       let tf = CustomTextField()
//        tf.textColor = .black
//        tf.font = UIFont(name: "LettersforLearners", size: 20)
//        tf.attributedPlaceholder = NSAttributedString(string: "나이", attributes: [.foregroundColor: UIColor.systemGray])
//        return tf
//    }()
//
//    lazy var petGenderSgControl: UISegmentedControl = {
//        let items = ["남", "여"]
//        let sg = UISegmentedControl(items: items)
//        sg.backgroundColor = .white
//        return sg
//    }()
    
    lazy var createProfileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        return btn
    }()
    
    
    // MARK: - ViewModel Properties
    
    let viewModel: SetupProfileViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: SetupProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "정보 입력"
        print("index: \(userGenderSgControl.selectedSegmentIndex)")
        setupView()
        binding()
    }

    // MARK: - Setup View
    
    private func setupView() {
        
//        view.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
//        view.addSubview(setupUserView)
//        setupUserView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
//        contentView.addSubview(setupPetView)
//        setupPetView.snp.makeConstraints { make in
//            make.top.equalTo(setupUserView.safeAreaLayoutGuide.snp.bottom).offset(10)
//            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
//            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
//        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(80)
        }
        
        view.addSubview(userNicknameTextField)
        userNicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-30)
            make.height.equalTo(30)
        }
        
        view.addSubview(userGenderSgControl)
        userGenderSgControl.snp.makeConstraints { make in
            make.top.equalTo(userNicknameTextField.snp.bottom).offset(15)
            make.centerX.equalTo(userNicknameTextField.snp.centerX)
            make.height.equalTo(userNicknameTextField.snp.height)
            make.width.equalTo(100)
        }
        
        view.addSubview(createProfileBtn)
        createProfileBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
//        setupPetView.addSubview(petNameTextField)
//        petNameTextField.snp.makeConstraints { make in
//            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(15)
//            make.centerX.equalTo(setupPetView.snp.centerX)
//            make.width.equalTo(50)
//            make.height.equalTo(userNicknameTextField.snp.height)
//        }
//
//        setupPetView.addSubview(petAgeTextField)
//        petAgeTextField.snp.makeConstraints { make in
//            make.top.equalTo(petNameTextField.snp.bottom).offset(15)
//            make.centerX.equalTo(petNameTextField.snp.centerX)
//            make.width.equalTo(petNameTextField.snp.width)
//            make.height.equalTo(petNameTextField.snp.height)
//        }
//
//        setupPetView.addSubview(petGenderSgControl)
//        petGenderSgControl.snp.makeConstraints { make in
//            make.top.equalTo(petAgeTextField.snp.bottom).offset(15)
//            make.centerX.equalTo(petAgeTextField.snp.centerX)
//            make.height.equalTo(petAgeTextField.snp.height)
//            make.width.equalTo(100)
//        }
        
        
        
        
        setupSegmentControl()
    }
    
    private func setupSegmentControl() {
        
        userGenderSgControl.selectedSegmentTintColor = .orange
        userGenderSgControl.tintColor = .white
        
//        petGenderSgControl.selectedSegmentTintColor = .orange
//        petGenderSgControl.tintColor = .white
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = SetupProfileViewModel.Input(usernickName: userNicknameTextField.rx.text.orEmpty.asDriver(),
                                                userGender: userGenderSgControl.rx.value.asDriver(),
                                                createTrigger: createProfileBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.createBtdEnabled
            .drive(createProfileBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive(onNext: { [weak self] _ in
                self?.viewModel.actionDelegate?.createProfile()
            }).disposed(by: disposeBag)
    }
}
