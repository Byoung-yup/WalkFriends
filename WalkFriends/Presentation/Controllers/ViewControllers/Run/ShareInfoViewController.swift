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
    
    lazy var addPhotoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("사진 추가하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 25)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    // MARK: - Properties
    
    let snapshotImage: UIImage
    
    let disposeBag = DisposeBag()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        binding()
    }
    
    // MARK: - Initiallize
    
    init(snapshot: UIImage) {
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
            make.left.right.bottom.equalToSuperview()
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
                print("tap")
                self?.updateUI()
            }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        
        addPhotoBtn.isHidden = true
    
        bottomView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.top).offset(60)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ShareInfoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
