//
//  MapListView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/06.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MapListView: UIView {
    
    // MARK: - UI Properties
    
    lazy var mapListTableView: UITableView = {
        let tbView = UITableView()
        tbView.backgroundColor = .white
        tbView.separatorStyle = .none
        tbView.register(MapListViewCell.self, forCellReuseIdentifier: MapListViewCell.identifier)
        return tbView
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
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        addSubview(mapListTableView)
        mapListTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalTo(safeAreaLayoutGuide.snp.left)
            make.right.equalTo(safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
