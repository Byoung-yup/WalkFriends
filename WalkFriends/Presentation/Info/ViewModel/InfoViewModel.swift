////
////  InfoViewModel.swift
////  WalkFriends
////
////  Created by 김병엽 on 2023/03/08.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
////protocol InfoViewControllerActionDelegate {
////    func logOut()
////}
//
//struct InfoViewModelActions {
//    let changeProfile: () -> Void
//    let showMyFavoriteMapListView: () -> Void
//    let signOut: () -> Void
//    let toBack: () -> Void
//}
//
//final class InfoViewModel: ViewModel {
//    
//    // MARK: - Input
//    
//    struct Input {
//        let logout: Observable<Void>
//        let finish: Observable<Void>
//    }
//    
//    // MARK: - Output
//    
//    struct Output {
//        let logout_Trigger: Observable<Result<Bool, FirebaseAuthError>>
//        let finishTrigger: Observable<Void>
//    }
//    
//    // MARK: - Properties
//    
//    let actions: InfoViewModelActions
////    var actionDelegate: InfoViewControllerActionDelegate?
//    
//    // MARK: - Init
//    init(actions: InfoViewModelActions) {
//        self.actions = actions
//    }
//    
//    // MARK: - Transform Method
//    
//    func transform(input: Input) -> Output {
//        
//        let logout = input.logout
//            .flatMap {
//                return FirebaseService.shard.logout()
//            }
//        
//        let dismiss = input.finish
//            .do(onNext: { [weak self] in
//                self?.actions.toBack()
//            })
//        
//        return Output(logout_Trigger: logout, finishTrigger: dismiss)
//    }
//}
//
//
