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
    
    lazy var titleView: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.text = "제목 입력"
        return lbl
    }()
    
    lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "LettersforLearners", size: 14)
        tf.addLeftPadding()
        tf.attributedPlaceholder = NSAttributedString(string: ".", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.main_Color.cgColor
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var lineView: Line = {
        let view = Line()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var photoLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.text = "사진 첨부"
        return lbl
    }()
    
    lazy var photoInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .lightGray
        lbl.backgroundColor = .white
        let attachment = NSTextAttachment()
        let imageSymbol = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        attachment.image = UIImage(systemName: "info.circle", withConfiguration: imageSymbol)?.withTintColor(.lightGray)
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: "")
        contentString.append(attachmentString)
        contentString.append(NSAttributedString(string: " 한 장의 사진이라도 포함되어야 합니다."))
        lbl.attributedText = contentString
        return lbl
    }()
    
    lazy var lineView2: Line = {
        let view = Line()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var addPhotoBtnView: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        let btn = UIButton(type: .system)
        btn.setImage(image, for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .orange
        btn.layer.borderColor = UIColor.main_Color.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width: 70, height: 70)
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.register(PhotoListCell.self, forCellWithReuseIdentifier: PhotoListCell.identifier)
        return view
    }()
    
    lazy var memoLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.text = "메모 작성"
        return lbl
    }()
    
    lazy var memoTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "LettersforLearners", size: 14)
        tf.addLeftPadding()
        tf.attributedPlaceholder = NSAttributedString(string: "메모를 남겨주세요.", attributes: [.foregroundColor: UIColor.systemGray])
        tf.textColor = .black
        tf.autocapitalizationType = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.main_Color.cgColor
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var lineView3: Line = {
        let view = Line()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.text = "시간"
        return lbl
    }()
    
    lazy var timeTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "LettersforLearners", size: 14)
        tf.textColor = .black
        tf.autocapitalizationType = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.main_Color.cgColor
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var minuteLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "LettersforLearners", size: 14)
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.text = "분"
        return lbl
    }()
    
    lazy var lineView4: Line = {
        let view = Line()
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
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right)
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(photoLbl)
        photoLbl.snp.makeConstraints { make in
            make.top.equalTo(lineView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        contentView.addSubview(addPhotoBtnView)
        addPhotoBtnView.snp.makeConstraints { make in
            make.top.equalTo(photoLbl.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.width.height.equalTo(70)
        }
        
        contentView.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.left.equalTo(addPhotoBtnView.safeAreaLayoutGuide.snp.right).offset(20)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.centerY.equalTo(addPhotoBtnView.snp.centerY)
            make.height.equalTo(70)
        }
        
        contentView.addSubview(photoInfoLbl)
        photoInfoLbl.snp.makeConstraints { make in
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.top.equalTo(addPhotoBtnView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
        }
        
        contentView.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(photoInfoLbl.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(memoLbl)
        memoLbl.snp.makeConstraints { make in
            make.top.equalTo(lineView2.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        contentView.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(memoLbl.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(200)
        }
        
        contentView.addSubview(lineView3)
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.top.equalTo(lineView3.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        contentView.addSubview(timeTextField)
        timeTextField.snp.makeConstraints { make in
            make.centerY.equalTo(timeLbl.snp.centerY)
            make.left.equalTo(timeLbl.safeAreaLayoutGuide.snp.right).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        contentView.addSubview(minuteLbl)
        minuteLbl.snp.makeConstraints { make in
            make.left.equalTo(timeTextField.safeAreaLayoutGuide.snp.right).offset(5)
            make.centerY.equalTo(timeLbl.snp.centerY)
        }
        
        contentView.addSubview(lineView4)
        lineView4.snp.makeConstraints { make in
            make.top.equalTo(timeLbl.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView4.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
    }
    
}
