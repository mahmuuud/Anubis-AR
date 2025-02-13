//
//  AppDelegate.swift
//  Anubis
//
//  Created by mahmoud mohamed on 3/18/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let _ = persistentContainer
        return true
    }
        
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContextChanges()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContextChanges()
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

    // MARK: CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MonumentsDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        DataSource.shared.persistentContainer = container
        DataSource.shared.viewContext = container.viewContext
        return container
    }()
    
    func saveContextChanges() {
        if persistentContainer.viewContext.hasChanges {
            try? persistentContainer.viewContext.save()
        }
    }

}

