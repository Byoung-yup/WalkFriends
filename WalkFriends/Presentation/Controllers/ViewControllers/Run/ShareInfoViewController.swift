//
//  ShareInfoViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BSImagePicker
import Photos
import RxGesture
//import RxKeyboard

class ShareInfoViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    //    lazy var scrollView: UIScrollView = {
    //        let scrollView = UIScrollView()
    //        scrollView.delegate = self
    //        return scrollView
    //    }()
    
//    lazy var imageView: UIImageView = {
//        let imgView = UIImageView()
//        imgView.contentMode = .scaleAspectFit
//        imgView.isUserInteractionEnabled = true
//        return imgView
//    }()
    
//    lazy var toBack_Btn: UIButton = {
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
//        let systemImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)
//        let btn = UIButton(type: .system)
//        btn.setImage(systemImage, for: .normal)
//        btn.tintColor = .black
//        btn.backgroundColor = .white
//        return btn
//    }()
    
    //    lazy var containerView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .white
    //        view.layer.cornerRadius = 15
    //        return view
    //    }()
    
    lazy var shareInfoView: ShareInfoView = {
        let view = ShareInfoView()
        view.backgroundColor = .white
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.layer.cornerRadius = 15
//        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("공유하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00)
        btn.layer.cornerRadius = 25
        btn.isEnabled = false
        return btn
    }()
    
    
    // MARK: - Properties
    
    let shareInfoViewModel: ShareInfoViewModel
    
    let disposeBag = DisposeBag()

    var userSelectedImages: PublishRelay = PublishRelay<[Data]>()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        toBack_Btn.layer.cornerRadius = toBack_Btn.frame.width / 2
    }
    
    // MARK: - Initiallize
    
    init(viewModel: ShareInfoViewModel) {
        shareInfoViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        //        imageView.image = snapshotImage
        
        
        //        scrollView.zoomScale = 1.0
        //        scrollView.minimumZoomScale = 1.0
        //        scrollView.maximumZoomScale = 2.0
        
        //        view.addSubview(scrollView)
        //        scrollView.snp.makeConstraints { make in
        //            make.top.left.right.equalToSuperview()
        //            make.bottom.equalToSuperview().offset(60)
        //        }
        
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        view.addSubview(indicatorView)
//        indicatorView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(100)
//        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        bottomView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(bottomView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(bottomView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(50)
        }
        
        submitBtn.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        view.addSubview(shareInfoView)
        shareInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(bottomView.safeAreaLayoutGuide.snp.top)
//            make.height.equalTo(imageView.snp.height).dividedBy(1.5)
        }
        
        
        
        //        containerView.addSubview(shareInfoView)
        //        shareInfoView.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        
//        imageView.addSubview(toBack_Btn)
//        toBack_Btn.snp.makeConstraints { make in
//            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left).offset(21)
//            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.top).offset(21)
//            make.width.height.equalTo(40)
//        }
        //
        //        bottomView.addSubview(addPhotoBtn)
        //        addPhotoBtn.snp.makeConstraints { make in
        //            make.centerX.centerY.equalToSuperview()
        //        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = ShareInfoViewModel.Input(selectedImages: userSelectedImages.asObservable(),
                                             titleText: shareInfoView.titleTextField.rx.text.orEmpty.asObservable(),
                                             memoText: shareInfoView.memoTextField.rx.text.orEmpty.asObservable(),
                                             timeText: shareInfoView.timeTextField.rx.text.orEmpty.asObservable(),
                                             submit: submitBtn.rx.tap.asObservable(),
                                             toBack: rx.isPopping.asObservable())
        let output = shareInfoViewModel.transform(input: input)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let imageData = self.shareInfoViewModel.mapInfo.imageData
            
            self.shareInfoView.addressInfoLbl.text = self.shareInfoViewModel.mapInfo.address
            self.shareInfoView.thumbnailView.image = UIImage(data: imageData)
        }
        
        output.dismiss
            .subscribe()
            .disposed(by: disposeBag)
        
        output.isLoding
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.isLoding
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] state in
                print("isLoding: \(state)")
                if state {
                    print("true excute")
                    self?.submitBtn.setTitle("", for: .normal)
                    self?.view.isUserInteractionEnabled = false
                }
//                else {
//                    print("false excute")
//                    self?.submitBtn.setTitle("공유하기", for: .normal)
//                    self?.view.isUserInteractionEnabled = true
//                }
                
            }).disposed(by: disposeBag)
        
        output.save_isEnabled
            .bind(to: submitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.save
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                print("result: \(result)")
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    self.shareInfoViewModel.actions.toBack()
                case .failure(let err):
                    self.showAlert(error: err)
                    self.shareInfoViewModel.actions.toBack()
                }
                
            }).disposed(by: disposeBag)
        
//        output.test
//            .subscribe()
//            .disposed(by: disposeBag)
        
        //        addPhotoBtn.rx.tap
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] in
        //                self?.updateUI()
        //            }).disposed(by: disposeBag)
        //
        shareInfoView.addPhotoBtnView.rx.tap
        //            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                self?.presentImagePicker()
            }).disposed(by: disposeBag)
        
        userSelectedImages.bind(to: shareInfoView.photoCollectionView.rx.items(cellIdentifier: PhotoListCell.identifier, cellType: PhotoListCell.self)) { row ,element , cell in
            cell.imageView.image = UIImage(data: element)
        }.disposed(by: disposeBag)
        
        shareInfoView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
//        RxKeyboard.instance.visibleHeight
//            .drive(onNext: { [weak self] keyboardHeight in
//                print("keyboard")
//                guard let self = self else { return }
//
//                let height = keyboardHeight > 0 ? -keyboardHeight + self.bottomView.frame.height : 0
//
//                self.shareInfoView.snp.updateConstraints {
//                    $0.bottom.equalTo(self.bottomView.safeAreaLayoutGuide.snp.top).offset(height)
//                }
//
//                self.view.layoutIfNeeded()
//
//            }).disposed(by: disposeBag)
        
        shareInfoView.memoTextField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.shareInfoView.scrollView.setContentOffset(CGPoint(x: 0, y: (self.shareInfoView.memoTextField.frame.origin.y) - self.shareInfoView.memoTextField.frame.height), animated: true)
            }).disposed(by: disposeBag)
        
        shareInfoView.timeTextField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.shareInfoView.scrollView.setContentOffset(CGPoint(x: 0, y: (self.shareInfoView.time_StackView.frame.origin.y) - self.shareInfoView.time_StackView.frame.height), animated: true)
            }).disposed(by: disposeBag)
        
        output.user_Map_Images
            .subscribe()
            .disposed(by: disposeBag)
        
        //        output.save
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] result in
        //                print("Result: \(result)")
        //                guard let strongSelf = self else { return }
        //
        //                switch result {
        //                case .success(_):
        //                    break
        ////                    strongSelf.shareInfoViewModel.actionDelegate?.dismiss()
        //                case .failure(let err):
        //                    strongSelf.showAlert(error: err)
        ////                    strongSelf.shareInfoViewModel.actionDelegate?.dismiss()
        //                }
        //
        //            }).disposed(by: disposeBag)
        //
        //        output.dismiss
        //            .drive()
        //            .disposed(by: disposeBag)
    }
    
    private func updateUI() {
        //        shareInfoView.addressView.text = address
        //
        //        mapImageRelay.accept([snapshotImage])
        //        addressRelay.accept(address)
        
        //        bottomView.snp.remakeConstraints { make in
        //            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.top).offset(60)
        //            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left)
        //            make.right.equalTo(imageView.safeAreaLayoutGuide.snp.right)
        //            make.bottom.equalToSuperview()
        //        }
        //
        //        bottomView.addSubview(shareInfoView)
        //        shareInfoView.snp.makeConstraints { make in
        //            make.top.equalTo(bottomView.safeAreaLayoutGuide.snp.top)
        //            make.left.equalTo(bottomView.safeAreaLayoutGuide.snp.left)
        //            make.right.equalTo(bottomView.safeAreaLayoutGuide.snp.right)
        //            make.bottom.equalTo(bottomView.safeAreaLayoutGuide.snp.bottom)
        //        }
    }
}

//extension ShareInfoViewController: UIScrollViewDelegate {
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//}

// MARK: - BSImagePicker

extension ShareInfoViewController {
    
    private func presentImagePicker() {
        
        let imagePicker = ImagePickerController()
        
        configureImagePicker(imagePicker, selection: 20)
        
        presentImagePicker(imagePicker, select: { (asset) in
            
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
            
        }, cancel: { (assets) in
            // User canceled selection.
            
        }, finish: { [weak self] (assets) in
            // User finished selection assets.
            
            var selectedAssets: [PHAsset] = []
            for i in assets {
                selectedAssets.append(i)
            }
            
            self?.convertAssetToImages(selectedAssets)
        })
    }
    
    private func convertAssetToImages(_ AssetImages: [PHAsset]) {
        
        if AssetImages.count != 0 {
            
            var imageDatas: [Data] = []
            
            for i in 0 ..< AssetImages.count {
                
                let imageManager = PHImageManager.default()
                
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: AssetImages[i], targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2), contentMode: .aspectFit, options: option) {
                    (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
//                let newImage = UIImage(data: data!)
                
                imageDatas.append(data!)
            }
            
            userSelectedImages.accept(imageDatas)
        }
    }
}
