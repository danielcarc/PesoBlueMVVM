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
//import FirebaseCore
//import FirebaseAnalytics
//import FirebaseFirestore
//import FirebaseAuth

      

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firebaseApp: FirebaseApp?
    var gidSignIn: GIDSignIn?
    var userService: UserService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        firebaseApp = FirebaseApp.app()
        gidSignIn = GIDSignIn.sharedInstance
        userService = UserService()
        Analytics.setAnalyticsCollectionEnabled(true)

        return true
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PesobluModel")
        container.loadPersistentStores {(store, error) in
            if let error = error as? NSError{
                fatalError("Unsolved error \(error), \(error.userInfo)")
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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
        print("Voy a pedir los settigs")
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler:
                                                                    {(settings: UNNotificationSettings) in
            if (settings.alertSetting == UNNotificationSetting.enabled) {
                print("Alert enabled")
            } else {
                print("Alert not enabled")
            }
            if (settings.badgeSetting == UNNotificationSetting.enabled) {
                print("Badge enabled")
            } else {
                print("Badge not enabled")
            }})
    }


}

