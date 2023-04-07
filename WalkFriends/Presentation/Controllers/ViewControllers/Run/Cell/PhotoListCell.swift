//
//  PhotoListCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/06.
//

import UIKit
import SnapKit

class PhotoListCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
