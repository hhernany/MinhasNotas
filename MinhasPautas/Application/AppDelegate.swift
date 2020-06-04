//
//  AppDelegate.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var isUITestingEnabled: Bool {
        get {
            return ProcessInfo.processInfo.arguments.contains("UI-Testing")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Load Firebase
        FirebaseApp.configure()
        
        // Check if is testing
        if AppDelegate.isUITestingEnabled {
            guard let viewController = LaunchEnvironment().setUp(using:ProcessInfo.processInfo.environment, userDefaults: UserDefaults.standard) else {
                return true
            }
            window?.rootViewController = viewController
        } else {
            // Open loginVC if user is not logged in
            if Auth.auth().currentUser == nil || UserDefaults.standard.object(forKey: "token_jwt") == nil {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("The user is not logged in or was unable to log out")
                }
                window?.rootViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            }
        }
        
        // Override point for customization after application launch.
        return true
    }
    
//    private func setStateForUITesting() {
//        if AppDelegate.isUITestingEnabled {
//            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        }
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MinhasPautas")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

final class LaunchEnvironment {
    typealias LaunchDictionary = [String: String]
    
    func setUp(using launchDictionary: LaunchDictionary, userDefaults: UserDefaults = .standard) -> UIViewController? {
        guard launchDictionary[ConfigurationKeys.isUITest]?.boolValue() == true else {
            return nil
        }
        guard let firstTimeUser = launchDictionary[ConfigurationKeys.isFirstTimeUser]?.boolValue() else {
            return nil
        }
        
        let viewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") // ViewController
        userDefaults.set(firstTimeUser, forKey: "is_first_time_user") // Save if is first login
        clearUserDefault() // Clear all user data
        setUpEnvironment(using: launchDictionary) // Save data in UserDefaults
        return firstTimeUser ? viewController : nil
    }
    
    private func clearUserDefault() {
        let defaults = UserDefaults.standard
        guard let domain = Bundle.main.bundleIdentifier else { fatalError("Invalid Bundle Identifier")}
        defaults.removePersistentDomain(forName: domain)
    }
    
    private func setUpEnvironment(using launchDictionary: LaunchDictionary) {
        for (key, value) in launchDictionary
            where key.hasPrefix("FakeData_") {
                // Truncate "UI-TestingKey_" part
                let userDefaultsKey = key.truncateKey()
                switch value {
                case "true":
                    UserDefaults.standard.set(true, forKey: userDefaultsKey)
                case "false":
                    UserDefaults.standard.set(false, forKey: userDefaultsKey)
                default:
                    UserDefaults.standard.set(value, forKey: userDefaultsKey)
                }
        }
    }
}
