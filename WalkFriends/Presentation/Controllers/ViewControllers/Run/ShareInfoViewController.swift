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

class ShareInfoViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    lazy var toBack_Btn: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let systemImage = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)
        let btn = UIButton(type: .system)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        return btn
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var shareInfoView: ShareInfoView = {
        let view = ShareInfoView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var addPhotoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("사진 추가하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 25)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    
    // MARK: - Properties
    
    let shareInfoViewModel: ShareInfoViewModel
    
    let disposeBag = DisposeBag()
    
    var mapImageRelay: BehaviorRelay = BehaviorRelay<[UIImage]>(value: [UIImage()])
    var addressRelay: BehaviorRelay = BehaviorRelay<String>(value: "")
    var userSelectedImages: PublishRelay = PublishRelay<[UIImage]>()
    
    var defaultImage: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        image?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        return image!
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toBack_Btn.layer.cornerRadius = toBack_Btn.frame.width / 2
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
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(imageView.safeAreaLayoutGuide.snp.right)
            make.bottom.equalToSuperview()
            make.height.equalTo(imageView.snp.height).dividedBy(1.5)
        }
        
        containerView.addSubview(shareInfoView)
        shareInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(toBack_Btn)
        toBack_Btn.snp.makeConstraints { make in
            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left).offset(21)
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.top).offset(21)
            make.width.height.equalTo(40)
        }
//
//        bottomView.addSubview(addPhotoBtn)
//        addPhotoBtn.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = ShareInfoViewModel.Input(addressText: addressRelay.asObservable(),
                                             selectedImages: mapImageRelay.asObservable(),
                                             titleText: shareInfoView.titleTextField.rx.text.orEmpty.asObservable(),
                                             memoText: shareInfoView.memoTextField.rx.text.orEmpty.asObservable(),
                                             submit: shareInfoView.submitBtn.rx.tap.asObservable(),
                                             toBack: toBack_Btn.rx.tap.asObservable())
        let output = shareInfoViewModel.transform(input: input)
        
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = output.mapInfo.image
            self?.shareInfoView.addressView.text = output.mapInfo.address
        }
        
        output.dismiss
            .subscribe()
            .disposed(by: disposeBag)
        
//        addPhotoBtn.rx.tap
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.updateUI()
//            }).disposed(by: disposeBag)
//
//        shareInfoView.addPhotoBtnView.rx.tap
////            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.presentImagePicker()
//            }).disposed(by: disposeBag)
//
//        userSelectedImages.bind(to: shareInfoView.photoCollectionView.rx.items(cellIdentifier: PhotoListCell.identifier, cellType: PhotoListCell.self)) { row ,element , cell in
//            cell.imageView.image = element
//        }.disposed(by: disposeBag)
        
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
        
        addPhotoBtn.isHidden = true
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

extension ShareInfoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

// MARK: - BSImagePicker

extension ShareInfoViewController {
    
    private func presentImagePicker() {
        
        var imagePicker = ImagePickerController()
    
        configureImagePicker(imagePicker, selection: 3)
        
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
            
            var images: [UIImage] = []
            
            for i in 0 ..< AssetImages.count {
                
                let imageManager = PHImageManager.default()
                
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: AssetImages[i], targetSize: CGSize(width: 200, height: 100), contentMode: .aspectFit, options: option) {
                    (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                images.append(newImage! as UIImage)
            }
            
            userSelectedImages.accept(images)
            mapImageRelay.accept(mapImageRelay.value + images)
        }
    }
}
