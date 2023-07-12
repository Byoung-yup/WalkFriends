//
//  InfoViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class InfoViewController: UIViewController {
    
    let infoViewModel: InfoViewModel
    
    let disposeBag = DisposeBag()
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그아웃", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    deinit {
        print("InfoViewController - deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "내 정보"
        
        ConfigureUI()
        binding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.orange.cgColor
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
    }
    
    // MARK: Initialize
    init(infoViewModel: InfoViewModel) {
        self.infoViewModel = infoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func ConfigureUI() {
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = InfoViewModel.Input(logout: logoutButton.rx.tap.asObservable())
        let output = infoViewModel.transform(input: input)
        
        output.logout_Trigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(_):
                    strongSelf.infoViewModel.actions.signOut()
                case .failure(let err):
                    strongSelf.showFBAuthErrorAlert(error: err)
                }
                
            }).disposed(by: disposeBag)
    }

}
