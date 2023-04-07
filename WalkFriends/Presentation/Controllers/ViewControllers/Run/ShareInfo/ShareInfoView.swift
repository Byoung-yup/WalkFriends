//
//  ShareInfoView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/06.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShareInfoView: UIView {
    
    // MARK: - UI Properties
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var addPhotoBtnView: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        
        let btn = UIButton(type: .system)
        btn.setImage(image, for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .orange
        return  btn
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = CGSize(width: 150, height: 100)
        flowLayout.scrollDirection = .horizontal
    
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.register(PhotoListCell.self, forCellWithReuseIdentifier: PhotoListCell.identifier)
        return view
    }()
    
    lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "제목 입력", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var setMemoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var memoTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.font = UIFont(name: "LettersforLearners", size: 20)
        tf.attributedPlaceholder = NSAttributedString(string: "메모 작성", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var submitView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("작성하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 20)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Properties
    
//    var userSelectedImages: PublishSubject = PublishSubject<[UIImage]>()
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            //            make.left.equalTo(safeAreaLayoutGuide.snp.left)
            //            make.right.equalTo(safeAreaLayoutGuide.snp.right)
            //            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(addPhotoBtnView)
        addPhotoBtnView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(200)
        }
        
        contentView.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addPhotoBtnView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(150)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(100)
        }
        
        titleView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.left.equalTo(titleView.safeAreaLayoutGuide.snp.left).offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(titleView.snp.height).dividedBy(2)
        }
        
        contentView.addSubview(setMemoView)
        setMemoView.snp.makeConstraints { make in
            make.top.equalTo(titleView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(200)
        }
        
        setMemoView.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.left.equalTo(setMemoView.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(setMemoView.safeAreaLayoutGuide.snp.right).offset(-20)
            make.top.equalTo(setMemoView.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(setMemoView.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        contentView.addSubview(submitView)
        submitView.snp.makeConstraints { make in
            make.top.equalTo(setMemoView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
            make.bottom.equalToSuperview()
            make.height.equalTo(150)
        }
        
        submitView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func binding() {
        
        
    }
}
