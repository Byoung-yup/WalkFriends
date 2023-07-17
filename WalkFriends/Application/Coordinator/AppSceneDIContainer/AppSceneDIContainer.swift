//
//  AppSceneDIContainer.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/11.
//

import Foundation
import UIKit

protocol AppSceneDIContainerDelegate {
    func dismiss(_ coordinator: Coordinator)
}

final class AppSceneDIContainer {
    
    var delegate: AppSceneDIContainerDelegate?
    
    // MARK: - Use Case
    func makeDefaultUseCase() -> DataUseCase {
        return DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager())
    }
    
    // MARK: - Login View
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController(loginViewModel: makeLoginViewModel(actions: actions))
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return LoginViewModel(actions: actions)
    }
    
    // MARK: - Register View
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
        return RegisterViewController(registerViewModel: makeRegisterViewModel(actions: actions))
    }
    
    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
        return RegisterViewModel(actions: actions)
    }
    
    // MARK: - Home View
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController(homeViewModel: makeHomeViewModel(actions: actions))
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(dataUseCase: makeDefaultUseCase(), actions: actions)
    }
    
    // MARK: - Setup View
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController {
        return SetupProfileViewController(viewModel: makeSetupProfileViewModel(actions: actions))
    }
    
    func makeSetupProfileViewModel(actions: SetupViewModelActions) -> SetupProfileViewModel {
        return SetupProfileViewModel(dataUseCase: makeDefaultUseCase(), actions: actions)
    }
    
    // MARK: - Info View
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController {
        return InfoViewController(infoViewModel: makeInfoViewModel(actions: actions))
    }
    
    func makeInfoViewModel(actions: InfoViewModelActions) -> InfoViewModel {
        return InfoViewModel(actions: actions)
    }
    
    // MARK: - Login Coordinator
    func makeLoginCoordinator(navigationController: UINavigationController) -> LoginCoordinator {
        return LoginCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: - Home Coordinator
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: - SetupProfile Coordinator
    func makeSetupProfileCoordinator(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) -> SetupProfileCoordinator {
        return SetupProfileCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: - Register Coordinator
    func makeRegisterCoordinator(navigationController: UINavigationController, dependencies: RegisterCoordinatorDependencies) -> RegisterCoordinator {
        return RegisterCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: - Info Coordinator
    func makeInfoCoordinator(navigationController: UINavigationController, dependencies: InfoCoordinatorDependencies) -> InfoCoordinator {
        return InfoCoordinator(navigationController: navigationController, dependecies: dependencies)
    }
    
    // MARK: - Dismiss LoginViewController
    func dismissLoginViewController(_ coordinator: LoginCoordinator) {
        delegate?.dismiss(coordinator)
    }
    
    // MARK: - Dismiss HomeViewController
    func dismissHomeViewController(_ coordinator: HomeCoordinator) {
        delegate?.dismiss(coordinator)
    }
}

extension AppSceneDIContainer: LoginCoordinatorDependencies {}
extension AppSceneDIContainer: HomeCoordinatorDepedencies {}
 
