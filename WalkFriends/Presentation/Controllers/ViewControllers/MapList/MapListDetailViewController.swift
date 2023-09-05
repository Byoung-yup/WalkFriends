//
//  MapListDetailViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MapListDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mapListDetailViewModel: MapListDetailViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private lazy var contentView: MapDetailView = {
        let view = MapDetailView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        confgureUI()
        binding()
    }
    
    // MARK: - Initialize
    
    init(mapListDetailViewModel: MapListDetailViewModel) {
        self.mapListDetailViewModel = mapListDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func confgureUI() {
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = MapListDetailViewModel.Input()
        let output = mapListDetailViewModel.transform(input: input)
        
        output.item
            .subscribe(onNext: { [weak self] item in
                
                guard let self = self else { return }
                print("item: \(item)")
                self.contentView.item = item
            }).disposed(by: disposeBag)
    }
    
}
