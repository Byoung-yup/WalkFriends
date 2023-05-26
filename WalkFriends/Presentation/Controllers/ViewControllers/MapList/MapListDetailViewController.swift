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
    
    let tableView: UITableView = {
       let view = UITableView()
        view.register(MapListDetailViewCell.self, forCellReuseIdentifier: MapListDetailViewCell.identifier)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Properties
    
    private let mapListDetailViewModel: MapListDetailViewModel
    
    let disposeBag = DisposeBag()
    
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = MapListDetailViewModel.Input()
        let output = mapListDetailViewModel.transform(input: input)
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.urls.drive(tableView.rx.items(cellIdentifier: "MapListDetailViewCell", cellType: MapListDetailViewCell.self)) { row, element, cell in
            cell.configureCell(url: element)
        }.disposed(by: disposeBag)
    }
    
    
}

extension MapListDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
