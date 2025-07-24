//
//  MainTabCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit
import CoreData

class MainTabCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    weak var appCoordinator: AppCoordinator?

    private var homeCoordinator: HomeCoordinator
    private var changeCoordinator: ChangeCoordinator!
    private var profileCoordinator: ProfileCoordinator!
    private var favoriteCoordinator: FavoriteCoordinator!
    

    init(window: UIWindow, appCoordinator: AppCoordinator? = nil,
         homeCoordinator: HomeCoordinator) {
        self.window = window
        self.navigationController = UINavigationController()
        self.appCoordinator = appCoordinator
        self.homeCoordinator = homeCoordinator
    }

    func start() {
        homeCoordinator = HomeCoordinator()
        homeCoordinator.start()

        changeCoordinator = ChangeCoordinator()
        changeCoordinator.start()

        profileCoordinator = ProfileCoordinator(navigationController: UINavigationController(), userService: UserService())
        profileCoordinator.parentCoordinator = self
        profileCoordinator.start()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        favoriteCoordinator = FavoriteCoordinator(navigationController: UINavigationController(), coreDataService: CoreDataService(context: context), placeService: PlaceService())
        favoriteCoordinator.start()

        let tabBar = PesoBlueTabBarController(
            viewControllers: [
                homeCoordinator.navigationController,
                changeCoordinator.navigationController,
                favoriteCoordinator.navigationController,
                profileCoordinator.navigationController
            ]
        )

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    func didSignOutFromProfile() {
        appCoordinator?.didFinishSession()
    }
}

