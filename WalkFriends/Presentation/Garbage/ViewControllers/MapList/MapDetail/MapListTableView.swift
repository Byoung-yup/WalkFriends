//
//  MapListTableView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/20.
//

import UIKit
import SnapKit
import FirebaseStorageUI

final class MapListTableView: UITableView {
    
    // MARK: - Properties
    
    private let height = UIScreen.main.bounds.height / 2.5
    private var heightConstant: NSLayoutConstraint!
    
    var storageRef: [StorageReference]? {
        didSet {
            setup_HeaderView()
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var image_ScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isPagingEnabled = true
        return view
    }()
    
    // MARK: - Init

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register()
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Configuration
    
    private func setupConfiguration() {
        
        backgroundColor = .white
        bounces = false
        sectionHeaderTopPadding = .zero
        contentInsetAdjustmentBehavior = .never
        indicatorStyle = .black
    }
    
    private func register() {
        register(MapListDetailViewCell.self, forCellReuseIdentifier: MapListDetailViewCell.identifier)
    }
    
    private func setup_HeaderView() {
        
        configureUI()
        
        guard let storageRef = storageRef else { return }
        
        for index in 1...(storageRef.count - 1) {
            
            let reference = storageRef[index]
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: reference)
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(index - 1)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height / 2)
            image_ScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index)
            image_ScrollView.addSubview(imageView)
        }
    }
    
    private func configureUI() {
        
        tableHeaderView = image_ScrollView
        tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        
//        containerView.addSubview(image_ScrollView)
//        image_ScrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y

        if offset > 0 {
            print("offset: \(offset)")
            let width = UIScreen.main.bounds.width
//            let height = height - offset
            image_ScrollView.frame = CGRect(x: 0, y: offset, width: width, height: height)
        }
    }
}

extension MapListTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
