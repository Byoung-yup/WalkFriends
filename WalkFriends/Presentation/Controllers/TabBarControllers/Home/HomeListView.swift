//
//  HomeListView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/22.
//

import UIKit
import SnapKit
import RxSwift

class HomeListView: UIView {
    
    // MARK: - Properties
    
//    let items: Observable<String> = Observable.of("Menu", "Profile", "Run", "None")
    
    // MARK: - UI Properties
    
    lazy var collectionView: UICollectionView = {
        // MARK: Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        let cellSize: CGFloat = (UIScreen.main.bounds.width - 40) / 2
        layout.itemSize = CGSize(width: cellSize - 40, height: 100)
        // MARK: CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeListCell.self, forCellWithReuseIdentifier: "HomeListCell")
        return collectionView
    }()
    
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
