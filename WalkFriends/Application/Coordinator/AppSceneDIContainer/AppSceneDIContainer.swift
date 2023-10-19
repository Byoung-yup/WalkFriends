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
    
    // MARK: - View
    
    // MARK: Launch View
    func makeLaunchViewController(actions: LaunchViewModelActions) -> LaunchViewController {
        return LaunchViewController(launchViewModel: makeLaunchViewModel(actions: actions))
    }
    
    func makeLaunchViewModel(actions: LaunchViewModelActions) -> LaunchViewModel {
        return LaunchViewModel(actions: actions)
    }
    
    // MARK: Location View
    func makeLocationViewController(actions: LocationViewModelActions) -> LocationViewController {
        return LocationViewController(locationViewModel: makeLocationViewModel(actions: actions))
    }
    
    func makeLocationViewModel(actions: LocationViewModelActions) -> LocationViewModel {
        return LocationViewModel(actions: actions)
    }
    
    // MARK: Login View
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController(loginViewModel: makeLoginViewModel(actions: actions))
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return LoginViewModel(actions: actions, dataUseCase: makeDefaultUseCase())
    }
    
    // MARK: Reset View
    func makeResetViewController(actions: ResetViewModelActions) -> ResetViewController {
        return ResetViewController(resetViewModel: makeResetViewModel(actions: actions))
    }
    
    func makeResetViewModel(actions: ResetViewModelActions) -> ResetViewModel {
        return ResetViewModel(actions: actions)
    }
    
    // MARK: Register View
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
        return RegisterViewController(registerViewModel: makeRegisterViewModel(actions: actions))
    }
    
    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
        return RegisterViewModel(actions: actions)
    }
    
    // MARK: Home View
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController(homeViewModel: makeHomeViewModel(actions: actions))
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(dataUseCase: makeDefaultUseCase(), actions: actions)
    }
    
    // MARK: Setup View
    func makeSetupProfileViewController(actions: SetupViewModelActions) -> SetupProfileViewController {
        return SetupProfileViewController(viewModel: makeSetupProfileViewModel(actions: actions))
    }
    
    func makeSetupProfileViewModel(actions: SetupViewModelActions) -> SetupProfileViewModel {
        return SetupProfileViewModel(dataUseCase: makeDefaultUseCase(), actions: actions)
    }
    
    // MARK: Run View
    func makeRunViewController(actions: RunViewModelActions) -> RunViewController {
        return RunViewController(viewModel: makeRunViewModel(actions: actions))
    }
    
    func makeRunViewModel(actions: RunViewModelActions) -> RunViewModel {
        return RunViewModel(actions: actions)
    }
    
    // MARK: Share View
    func makeShareViewController(actions: ShareInfoViewModelActions, mapInfo: MapInfo) -> ShareInfoViewController {
        return ShareInfoViewController(viewModel: makeShareViewModel(actions: actions, mapInfo: mapInfo))
    }
    
    func makeShareViewModel(actions: ShareInfoViewModelActions, mapInfo: MapInfo) -> ShareInfoViewModel {
        return ShareInfoViewModel(dataUseCase: makeDefaultUseCase(), actions: actions, mapInfo: mapInfo)
    }
    
    // MARK: MapListDetail View
    func makeMapListDetailViewController(actions: MapListDetailViewModelActions, item: FinalMapList) -> MapListDetailViewController {
        return MapListDetailViewController(mapListDetailViewModel: makeMapListDetailViewModel(actions: actions, item: item))
    }
    
    func makeMapListDetailViewModel(actions: MapListDetailViewModelActions, item: FinalMapList) -> MapListDetailViewModel {
        return MapListDetailViewModel(dataUseCase: makeDefaultUseCase(), item: item, actions: actions)
    }
    
    // MARK: Info View
    func makeInfoViewController(actions: InfoViewModelActions) -> InfoViewController {
        return InfoViewController(infoViewModel: makeInfoViewModel(actions: actions))
    }
    
    func makeInfoViewModel(actions: InfoViewModelActions) -> InfoViewModel {
        return InfoViewModel(actions: actions)
    }
    
    // MARK: - Coordinator
    
    // MARK: Launch Coordinator
    func makeLaunchCoordinator(navigationController: UINavigationController) -> LaunchCoordinator {
        return LaunchCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: Location Coordinator
    func makeLaunchCoordinator(navigationController: UINavigationController, dependencies: LocationCoordinatorDependencies) -> LocationCoordinator {
        return LocationCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Login Coordinator
    func makeLoginCoordinator(navigationController: UINavigationController, dependencies: LoginCoordinatorDependencies) -> LoginCoordinator {
        return LoginCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Reset Coordinator
    func makeResetCoordinator(navigationController: UINavigationController, dependencies: ResetCoordinatorDependencies) -> ResetCoordinator {
        return ResetCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Register Coordinator
    func makeRegisterCoordinator(navigationController: UINavigationController, dependencies: RegisterCoordinatorDependencies) -> RegisterCoordinator {
        return RegisterCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Home Coordinator
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: SetupProfile Coordinator
    func makeSetupProfileCoordinator(navigationController: UINavigationController, dependencies: SetupProfileCoordinatorDependencies) -> SetupProfileCoordinator {
        return SetupProfileCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Run Coordinator
    func makeRunCoordinator(navigationController: UINavigationController, dependencies: RunCoordinatorDependencies) -> RunCoordinator {
        return RunCoordinator(navigationController: navigationController, dependencies: dependencies)
    }
    
    // MARK: Share Coordinator
    func makeShareCoordinator(navigationController: UINavigationController, dependencies: ShareInfoCoordinatorDepedencies, mapInfo: MapInfo) -> ShareInfoCoordinator {
        return ShareInfoCoordinator(navigationController: navigationController, dependenceis: dependencies, mapInfo: mapInfo)
    }
    
    // MARK: MapListDetail Coordinator
    func makeMapListDetailCoordinator(navigationController: UINavigationController, dependencies: MapListDetailCoordinatorDependencies, item: FinalMapList) -> MapListDetailCoordinator {
        return MapListDetailCoordinator(navigationController: navigationController, dependencies: dependencies, item: item)
    }
    
    // MARK: Info Coordinator
    func makeInfoCoordinator(navigationController: UINavigationController, dependencies: InfoCoordinatorDependencies) -> InfoCoordinator {
        return InfoCoordinator(navigationController: navigationController, dependecies: dependencies)
    }
    
    // MARK: - Dismiss
    
    // MARK: Dismiss LoginViewController
    func dismissLoginViewController(_ coordinator: LoginCoordinator) {
        delegate?.dismiss(coordinator)
    }
    
    // MARK: Dismiss HomeViewController
    func dismissHomeViewController(_ coordinator: HomeCoordinator) {
        delegate?.dismiss(coordinator)
    }
}

extension AppSceneDIContainer: LaunchCoordinatorDependencies {}
extension AppSceneDIContainer: LoginCoordinatorDependencies {}
extension AppSceneDIContainer: HomeCoordinatorDependencies {}
 
