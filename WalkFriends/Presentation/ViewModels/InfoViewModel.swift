//
//  InfoViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/08.
//

import Foundation

protocol InfoViewControllerActionDelegate {
    func logOut() 
}

final class InfoViewModel {
    
    var actionDelegate: InfoViewControllerActionDelegate?
    
}

extension InfoViewModel {
    
    // MARK: - View event methods
    
    func logOut() {
        actionDelegate?.logOut()
    }
}
