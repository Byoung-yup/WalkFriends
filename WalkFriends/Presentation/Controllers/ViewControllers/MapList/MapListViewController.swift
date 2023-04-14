//
//  MapListViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/14.
//

import Foundation
import UIKit
import SnapKit

class MapListViewController: UIViewController {
    
    // MARK: - Properties
    
    let mapListViewModel: MapListViewModel
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Initialize
    
    init(mapListViewModel: MapListViewModel) {
        self.mapListViewModel = mapListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FetchMapListData
    
    private func fetchMapListData() {
        
        
    }
}
