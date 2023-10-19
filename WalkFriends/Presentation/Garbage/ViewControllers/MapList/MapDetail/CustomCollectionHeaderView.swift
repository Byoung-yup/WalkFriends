//
//  CustomCollectionHeaderView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/12.
//

import UIKit
import SnapKit
import FirebaseStorageUI

class CustomCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Utils

    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Properties
    
    var storageRef: [StorageReference]?
    
    // MARK: - UI Properties
    
    private lazy var image_ScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
//        view.bounces = false
        return view
    }()
    
    private lazy var pageLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .black.withAlphaComponent(0.5)
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var bgImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "Register_View_Bg")
        return imgView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setDelegate()
        setup_HeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Methods
    
    private func configureUI() {
//        print("configureUI")
        addSubview(image_ScrollView)
        image_ScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(image_ScrollView.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-21)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    private func setDelegate() {
        image_ScrollView.delegate = self
    }
    
    func setup_HeaderView() {
        
        guard let storageRef = storageRef else { return }
        
        pageLabel.text = "1 / \(storageRef.count - 1)"
        
        var beforeView: UIImageView?

        for index in 1...(storageRef.count - 1) {

            let reference = storageRef[index]

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: reference)

//            let xPosition = UIScreen.main.bounds.width * CGFloat(index - 1)
//            imageView.frame = CGRect(x: xPosition,
//                                     y: 0,
//                                     width: frame.width,
//                                     height: frame.height)
//            image_ScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index)
            image_ScrollView.addSubview(imageView)
            
            if index == 1 {
                
                imageView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(image_ScrollView)
                    make.left.equalTo(image_ScrollView)
                    make.width.equalTo(snp.width)
                    make.height.equalTo(snp.height)
                }
                
                beforeView = imageView
            }
            else if index == (storageRef.count - 1) {
                
                imageView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(image_ScrollView)
                    make.left.equalTo(beforeView!.snp.right)
                    make.right.equalTo(image_ScrollView)
                    make.width.equalTo(snp.width)
                    make.height.equalTo(snp.height)
                }
                
                beforeView = imageView
            }
            else {
                
                imageView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(image_ScrollView)
                    make.left.equalTo(beforeView!.snp.right)
                    make.width.equalTo(snp.width)
                    make.height.equalTo(snp.height)
                }
                
                beforeView = imageView
            }
        }
    }
}

extension CustomCollectionHeaderView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageLabel.text = "\(Int(round(image_ScrollView.contentOffset.x / UIScreen.main.bounds.width)) + 1) / \((storageRef!.count) - 1)"
    }
}
