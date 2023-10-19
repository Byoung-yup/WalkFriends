//
//  BackgroundView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/19.
//

import UIKit
import SnapKit

class BackgroundView: UIView {
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "검색 결과가 없어요.\n주소를 다시 확인해주세요!"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.textAlignment = .center
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func configureUI() {
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }
    }
}
