//
//  AppDelegate.swift
//  mc69424-DreamScape
//
//  Created by Michael Cheng on 11/28/23.
//

import UIKit
import SwiftUI
import FirebaseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let userViewModel = UserViewModel()
        let authViewModel = AuthViewModel()
        let contentView = ContentView()
            .environmentObject(authViewModel)
            .environmentObject(userViewModel)
            .environmentObject(SharedViewModel())
        
        // Read the user's dark mode preference and apply it
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        AppearanceManager.updateAppearance(darkModeEnabled: isDarkModeEnabled)
        
        let isNotificationEnabled = UserDefaults.standard.bool(forKey: "isNotificationEnabled")
        
        if isNotificationEnabled {
            // Check the current notification settings
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .authorized {
                        // The app has notification permissions
                        // Reschedule the notifications if needed
                        NotificationManager.shared.scheduleReminderNotification()
                    } else {
                        // The app does not have permission
                        UserDefaults.standard.set(false, forKey: "isNotificationEnabled")
                    }
                }
            }
        }
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

