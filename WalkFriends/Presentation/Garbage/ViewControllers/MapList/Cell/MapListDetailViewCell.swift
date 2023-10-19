//
//  MapListDetailViewCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/05/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MapListDetailViewCell: UITableViewCell {
    
    // MARK: UI Properties
    
    // MARK: - Properties
    
    var bg_Num: Int?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initailize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = .clear
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        
        let bg_Num = Int.random(in: 1...4)
        
        if bg_Num == 1 {
            backgroundColor = .red
        }
        else if bg_Num == 2 {
            backgroundColor = .purple
        }
        else if bg_Num == 3 {
            backgroundColor = .gray
        }
        else {
            backgroundColor = .blue
        }
    }
    
    func configureCell(url: String) {
        

    }
    
}
