//
//  AppDelegate.swift
//  ReleaseDate
//
//  Created by Pete Connor on 3/22/20.
//  Copyright © 2020 Pete Connor. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace
// refactor - done

import UIKit
import CoreData
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationManager = NotificationManager()
    let nextAirDate = NextAirDate()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                //print("error loading persistentContainer")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //print("error saving context")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        notificationManager.requestNotificationAuthorization()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.c0nman.Shows.fetch",
                                        using: nil) { (task) in
          self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        //print("task scheduled")
        }
        
        return true
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        //print("handle app refresh")
        
        nextAirDate.getCoreDataAndCheckNextAirDate(backgroundTrueForegroundFalse: true)
        task.setTaskCompleted(success: true)
        
        scheduleBackgroundFetch()
    }
    
    func scheduleBackgroundFetch() {
        let fetchTask = BGAppRefreshTaskRequest(identifier: "com.c0nman.Shows.fetch")
        fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
          try BGTaskScheduler.shared.submit(fetchTask)
            //print("background fetch scheduled")
        } catch {
          //print("Unable to submit task: \(error.localizedDescription)")
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
}