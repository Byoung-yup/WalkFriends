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
    
    lazy var mapImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Properties
    
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
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        
        contentView.addSubview(mapImageView)
        mapImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(url: String) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx
            .response(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_, data) in
                self?.mapImageView.image = UIImage(data: data)
            }).disposed(by: disposeBag)
    }
    
}
