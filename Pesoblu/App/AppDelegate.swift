//
//  AppDelegate.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 29/09/23.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreData

      

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firebaseApp: FirebaseApp?
    var gidSignIn: GIDSignIn?
    var userService: UserService?
    
    // Helper to detect test environment
    private var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if isRunningTests {
            // Evitamos inicializar toda la app en modo test
            return true
        }
        
        FirebaseApp.configure()
        firebaseApp = FirebaseApp.app()
        gidSignIn = GIDSignIn.sharedInstance
        userService = UserService()
        Analytics.setAnalyticsCollectionEnabled(true)

        return true
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PesobluModel")
        container.loadPersistentStores { [weak self] (store, error) in
            if let error = error as? NSError {
                AppLogger.error("Unsolved error \(error), \(error.userInfo)")
                self?.showErrorScreen(message: "Failed to load database.")
            }
        }
        return container
    }()
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            }
            catch{
                let nserror = error as NSError
                AppLogger.error("Unresolved error \(nserror), \(nserror.userInfo)")
                showErrorScreen(message: "Failed to save data.")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AppLogger.debug("Voy a pedir los settigs")
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler:
                                                                    {(settings: UNNotificationSettings) in
            if (settings.alertSetting == UNNotificationSetting.enabled) {
                AppLogger.debug("Alert enabled")
            } else {
                AppLogger.debug("Alert not enabled")
            }
            if (settings.badgeSetting == UNNotificationSetting.enabled) {
                AppLogger.debug("Badge enabled")
            } else {
                AppLogger.debug("Badge not enabled")
            }})
    }


}

private extension AppDelegate {
    func showErrorScreen(message: String) {
        let errorVC = ErrorViewController(message: message)
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.rootViewController = errorVC
        window?.makeKeyAndVisible()
    }
}

