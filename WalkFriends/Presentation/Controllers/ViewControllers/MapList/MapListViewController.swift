//
//  MapListViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MapListViewController: UIViewController {
    
    // MARK: - UI Properties
    
    let tableView: UITableView = {
       let view = UITableView()
        view.register(MapListViewCell.self, forCellReuseIdentifier: MapListViewCell.identifier)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Properties
    
    let mapListViewModel: MapListViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        confgureUI()
        binding()

    }
    
    // MARK: - Initialize
    
    init(mapListViewModel: MapListViewModel) {
        self.mapListViewModel = mapListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func confgureUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = MapListViewModel.Input()
        let output = mapListViewModel.transform(input: input)
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.mapList.bind(to: tableView.rx.items(cellIdentifier: "MapListViewCell", cellType: MapListViewCell.self)) { row, element, cell in
            cell.mapList = element
        }.disposed(by: disposeBag)
        
        
    }
}

extension MapListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
