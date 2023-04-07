//
//  ShareInfoViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class ShareInfoViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let selectedImages: Driver<[UIImage]>
        let titleText: Driver<String>
        let memoText: Driver<String>
        let submit: Driver<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let updateImages: Driver<[UIImage]>
    }
    
    // MARK: - Properties
    
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        return Output(updateImages: input.selectedImages)
    }
}
//
//// MARK: - UITableViewDataSource
//
//extension ShareInfoViewModel: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if section == 0 {
//            return 1
//        } else {
//            return
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultPhotoViewCell.identifier, for: indexPath) as! DefaultPhotoViewCell
//            cell.isHighlighted = false
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListCell.identifier, for: indexPath) as! PhotoListCell
//            cell.isHighlighted = false
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//
//}
//
//// MARK: - UITableViewDelegate
//
//extension ShareInfoViewModel: UITableViewDelegate {
//
//}
