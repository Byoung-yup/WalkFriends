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
import RxGesture

class SetupProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        let defaultImage = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.image = defaultImage
        imageV.isUserInteractionEnabled = true
        return imageV
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
    
    lazy var createProfileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        return btn
    }()
    
    
    // MARK: - Properties
    
    let viewModel: SetupProfileViewModel
    
    let defaultImage: BehaviorSubject<UIImage> = BehaviorSubject<UIImage>(value: UIImage(systemName: "person.crop.circle")!)
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(viewModel: SetupProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "정보 입력"
        print("index: \(userGenderSgControl.selectedSegmentIndex)")
        configureUI()
        binding()
    }
    
    // MARK: - Setup View
    
    private func configureUI() {
        
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
        
        setupSegmentControl()
    }
    
    private func setupSegmentControl() {
        
        userGenderSgControl.selectedSegmentTintColor = .orange
        userGenderSgControl.tintColor = .white
        
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = SetupProfileViewModel.Input(profileImage: defaultImage.asDriver(onErrorJustReturn: UIImage()),
                                                usernickName: userNicknameTextField.rx.text.orEmpty.asDriver(),
                                                userGender: userGenderSgControl.rx.value.asDriver(),
                                                createTrigger: createProfileBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.createBtdEnabled
            .drive(createProfileBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive()
            .disposed(by: disposeBag)
        
        imageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.imagePicker()
            }).disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker

extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func imagePicker() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: false) { [weak self] in
            
            guard let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                return
            }

            self?.imageView.image = img
            
            self?.defaultImage.onNext(img)
        }
    }
}
