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
import BSImagePicker
import Photos

class SetupProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        let defaultImage = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.image = defaultImage
        imageV.tintColor = .main_Color
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    
    lazy var userNicknameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.addLeftPadding()
        tf.textColor = .black
        tf.font = UIFont(name: "LettersforLearners", size: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임(2글자 이상)", attributes: [.foregroundColor: UIColor.systemGray])
        return tf
    }()
    
//    lazy var userGenderSgControl: UISegmentedControl = {
//        let items = ["남", "여"]
//        let sg = UISegmentedControl(items: items)
//        sg.backgroundColor = .white
//        return sg
//    }()
    
    lazy var createProfileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.backgroundColor = .main_Color
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.layer.cornerRadius = 25
        btn.isEnabled = false
        return btn
    }()
    
    
    // MARK: - Properties
    
    let setupProfileViewModel: SetupProfileViewModel
    
    let defaultImage: BehaviorRelay<UIImage> = BehaviorRelay<UIImage>(value: UIImage(systemName: "person.crop.circle")!)
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(viewModel: SetupProfileViewModel) {
        self.setupProfileViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "프로필 설정"
        navigationItem.hidesBackButton = true
//        print("index: \(userGenderSgControl.selectedSegmentIndex)")
        drawBackground()
        configureUI()
        
        binding()
        
    }
    
    // MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2

    }
    
    // MARK: - Setup View
    
    private func configureUI() {
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(130)
        }
        
        view.addSubview(userNicknameTextField)
        userNicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
//        view.addSubview(userGenderSgControl)
//        userGenderSgControl.snp.makeConstraints { make in
//            make.top.equalTo(userNicknameTextField.snp.bottom).offset(15)
//            make.centerX.equalTo(userNicknameTextField.snp.centerX)
//            make.height.equalTo(userNicknameTextField.snp.height)
//            make.width.equalTo(100)
//        }
        
        view.addSubview(createProfileBtn)
        createProfileBtn.snp.makeConstraints { make in
            make.top.equalTo(userNicknameTextField.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(userNicknameTextField.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(userNicknameTextField.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
        
//        setupSegmentControl()
    }
    
//    private func setupSegmentControl() {
//        
//        userGenderSgControl.selectedSegmentTintColor = .orange
//        userGenderSgControl.tintColor = .white
//        
//    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = SetupProfileViewModel.Input(profileImage: defaultImage.asObservable(),
                                                usernickName: userNicknameTextField.rx.text.orEmpty.asObservable(),
                                                createTrigger: createProfileBtn.rx.tap.asObservable())
        let output = setupProfileViewModel.transform(input: input)
        
        output.createEnabled
            .drive(createProfileBtn.rx.isEnabled)
            .disposed(by: disposeBag)

        output.create
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in

                guard let strongSelf = self else { return }

                switch result {
                case .success(_):
                    break
                case .failure(let err):
                    strongSelf.showAlert(error: err)
                }

            }).disposed(by: disposeBag)
        
        imageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] event in
                print("touch: \(event)")
                guard let strongSelf = self else { return }
                
                strongSelf.presentImagePicker()
          
            }).disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker

extension SetupProfileViewController {
    
    private func presentImagePicker() {

        let imagePicker = ImagePickerController()

        configureImagePicker(imagePicker, selection: 1)

        self.presentImagePicker(imagePicker) { asset in

        } deselect: { _ in

        } cancel: { _ in

        } finish: { [weak self] (asset) in

            guard let strongSelf = self else { return }

            let images = strongSelf.convertAssetToImage(asset, size: CGSize(width: 100, height: 100))

            strongSelf.defaultImage.accept(images.first!)

            DispatchQueue.main.async {
                strongSelf.imageView.image = images.first
            }
        }

    }
}
