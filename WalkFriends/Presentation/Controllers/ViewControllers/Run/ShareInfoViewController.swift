//
//  ShareInfoViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/31.
//

import Foundation
import UIKit
import SnapKit

class ShareInfoViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    // MARK: - Properties
    
    let snapshotImage: UIImage
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        
        imageView.image = snapshotImage
    }
    
    // MARK: - Initiallize
    
    init(snapshot: UIImage) {
        snapshotImage = snapshot
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
