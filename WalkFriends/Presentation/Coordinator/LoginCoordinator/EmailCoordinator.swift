////
////  EmailCoordinator.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/05/12.
////
//
//import Foundation
//import UIKit
//
//class EmailCoordinator: NSObject, Coordinator {
//    
//    var childCoordinators: [NSObject] = []
//    
//    private let viewcontroller: UIViewController!
//    
//    init(viewcontroller: UIViewController) {
//        self.viewcontroller = viewcontroller
//    }
//    
//    func start() {
//        let emailConfirmViewController = EmailConfirmViewController(emailConfirmViewModel: makeViewModel())
//        emailConfirmViewController.modalPresentationStyle = .overCurrentContext
//        viewcontroller.present(emailConfirmViewController, animated: false)
//    }
//    
//    // MARK: - EmailConfirmViewController
//    func makeViewModel() -> EmailConfirmViewModel {
//        let viewModel = EmailConfirmViewModel()
//        return viewModel
//    }
//}
