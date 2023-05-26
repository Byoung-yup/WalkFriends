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

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
//    lazy var profileView: ProfileView = {
//       let view = ProfileView()
//        view.backgroundColor = .orange
//        return view
//    }()
    
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
        
//        profileView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        profileView.layer.cornerRadius = 20
        
//        profileView.layer.shadowColor = UIColor.gray.cgColor
//        profileView.layer.shadowRadius = 20
//        profileView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        profileView.layer.shadowOpacity = 0.5

    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
//        view.addSubview(profileView)
//        profileView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(200)
//        }
        
        view.addSubview(homeListView)
        homeListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Binding
    
    private func Binding() {
        
        let input = HomeViewModel.Input(selectedMenu: homeListView.collectionView.rx.itemSelected.asDriver())
        let output = homeViewModel.transform(input: input)
        
        output.trigger
            .drive()
            .disposed(by: disposeBag)
        
        output.fetchTrigger
            .drive(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(_):
                    break
                case .failure(let err):
                    
                    if err == .NotFoundUserError {
                        strongSelf.homeViewModel.actionDelegate?.setupProfile()
                    }
                    else {
                        strongSelf.homeViewModel.actionDelegate?.error()
                        strongSelf.showAlert(error: err)
                    }
                }
                
            }).disposed(by: disposeBag)
            
        homeViewModel.items
            .bind(to: homeListView.collectionView.rx.items(cellIdentifier: "HomeListCell", cellType: HomeListCell.self)) { (row, text, cell) in
                cell.label.text = "\(text)"
            }.disposed(by: disposeBag)
        
        homeListView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    
    }
    
//    // MARK: - loadUserProfile
//
//    private func loadUserProfile() {
//
//        homeViewModel.fetchMyProfileData()
//            .subscribe(onNext: { [weak self] result in
//
//                if result {
//                    
//                } else {
//                    self?.setupProfile()
//                }
//            }).disposed(by: disposeBag)
//
//    }
//
//    // MARK: - setupProfile
//
//    private func setupProfile() {
//        homeViewModel.setupProfileView()
//    }

}
