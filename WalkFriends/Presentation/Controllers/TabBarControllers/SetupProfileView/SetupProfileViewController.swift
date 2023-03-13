//
//  SetupProfileViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/10.
//

import UIKit
import SnapKit

class SetupProfileViewController: UIViewController {
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .red
        return contentView
    }()
    
    
    
    let viewModel: SetupProfileViewModel
    
    init(viewModel: SetupProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "정보 입력"
        
        setupView()
    }

    // MARK: - Set up View
    
    private func setupView() {
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
    }
    
    // MARK: - Binding
    
}
