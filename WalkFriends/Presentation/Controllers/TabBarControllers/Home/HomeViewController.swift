//
//  HomeViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    lazy var profileView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var homeListView: HomeListView = {
        let view = HomeListView()
        view.backgroundColor = .blue
        return view
    }()
    
    // MARK: - Initialize
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
//        loadUserProfile()
        Binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        profileView.layer.cornerRadius = 20
        
        profileView.layer.shadowColor = UIColor.gray.cgColor
        profileView.layer.shadowRadius = 20
        profileView.layer.shadowOffset = CGSize(width: 0, height: 10)
        profileView.layer.shadowOpacity = 0.5

    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(200)
        }
        
        view.addSubview(homeListView)
        homeListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(profileView.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(80)
        }
    }
    
    // MARK: - Binding
    
    private func Binding() {
        
        homeViewModel.items
            .bind(to: homeListView.collectionView.rx.items(cellIdentifier: "HomeListCell", cellType: HomeListCell.self)) { (row, text, cell) in
                print("row: \(row), text: \(text), cell: \(cell)")
                cell.label.text = "\(text)"
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - loadUserProfile
    
    private func loadUserProfile() {
        
        homeViewModel.fetchMyProfileData()
            .subscribe(onNext: { [weak self] userProfile in
                
                if userProfile != nil {
                    
                } else {
                    self?.setupProfile()
                }
            }).disposed(by: disposeBag)
            
    }
    
    // MARK: - setupProfile
    
    private func setupProfile() {
        homeViewModel.setupProfileView()
    }

}
