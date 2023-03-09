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
import FirebaseAuth

class HomeViewController: UIViewController {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    lazy var profileView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeViewController - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureUI()
        loadUserProfile()
        
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
    
    // MARK: Configure UI
    private func configureUI() {
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(200)
        }
        
    }
    
    // MARK: checkUserProfile
    private func loadUserProfile() {
        
        homeViewModel.fetchMyProfileData()
            
    }

}
