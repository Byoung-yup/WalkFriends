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
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
    
    let snapshotImage: UIImage
    
    let disposeBag = DisposeBag()
    
    var userSelectedImages: PublishSubject = PublishSubject<[UIImage]>()
    
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
    
    // MARK: - Initiallize
    
    init(viewModel: ShareInfoViewModel, snapshot: UIImage) {
        shareInfoViewModel = viewModel
        snapshotImage = snapshot
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomView.layer.cornerRadius = 30
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        imageView.image = snapshotImage
        
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        
        //        view.addSubview(scrollView)
        //        scrollView.snp.makeConstraints { make in
        //            make.top.left.right.equalToSuperview()
        //            make.bottom.equalToSuperview().offset(60)
        //        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(imageView.safeAreaLayoutGuide.snp.right)
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bottomView.addSubview(addPhotoBtn)
        addPhotoBtn.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        addPhotoBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.updateUI()
            }).disposed(by: disposeBag)
        
        shareInfoView.addPhotoBtnView.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.presentImagePicker()
            }).disposed(by: disposeBag)
        
        userSelectedImages.bind(to: shareInfoView.photoCollectionView.rx.items(cellIdentifier: PhotoListCell.identifier, cellType: PhotoListCell.self)) { row ,element , cell in
            cell.imageView.image = element
        }.disposed(by: disposeBag)
    }
    
    private func updateUI() {
        
        addPhotoBtn.isHidden = true
        
        bottomView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.top).offset(60)
            make.left.equalTo(imageView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(imageView.safeAreaLayoutGuide.snp.right)
            make.bottom.equalToSuperview()
        }
        
        bottomView.addSubview(shareInfoView)
        shareInfoView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(bottomView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(bottomView.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(bottomView.safeAreaLayoutGuide.snp.bottom)
        }
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
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 3
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.theme.selectionFillColor = .orange
        imagePicker.doneButton.tintColor = .orange
        imagePicker.doneButtonTitle = "확인"
        imagePicker.cancelButton.title = "닫기"
        imagePicker.cancelButton.tintColor = .orange
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
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
            
            self?.convertAssetToImage(selectedAssets)
        })
    }
    
    private func convertAssetToImage(_ AssetImages: [PHAsset]) {
        
        if AssetImages.count != 0 {
            
            var images: [UIImage] = []
            
            for i in 0 ..< AssetImages.count {
                
                let imageManager = PHImageManager.default()
                
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: AssetImages[i], targetSize: CGSize(width: 200, height: 100), contentMode: .aspectFill, options: option) {
                    (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                images.append(newImage! as UIImage)
            }
            
            userSelectedImages.onNext(images)
        }
    }
}
