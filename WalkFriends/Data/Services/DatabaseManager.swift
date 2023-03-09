//
//  DatabaseManager.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/07.
//

import Foundation
import UIKit
import FirebaseFirestore
import RxSwift

final class DatabaseManager {
    
    private let db = Firestore.firestore()

    
}

extension DatabaseManager: UserProfileRepository {
    
    func fetchUserProfile() {
        
        db.collection("User").document(UserInfo.shared.uid!).getDocument { (document, error) in
            
        }
    }
    
}
