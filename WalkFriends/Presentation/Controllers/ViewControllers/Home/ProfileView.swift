//
//  ProfileView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/07.
//

import Foundation
import UIKit
import SnapKit

class ProfileView: UIView {
    
    // MARK: - UI Properties
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let view = UIImageView()
        view.backgroundColor = .white
        view.image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        view.tintColor = .cyan
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nickNameView: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        lbl.textColor = .black
        return lbl
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
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(70)
        }
        
        addSubview(nickNameView)
        nickNameView.snp.makeConstraints { make in
            make.top.equalTo(imageView.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(imageView.snp.left)
            
        }
    }
}
