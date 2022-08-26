//
//  AppDelegate.swift
//  Task_25_elizbar
//
//  Created by alta on 8/24/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupNotification(on: application)
        return true
        
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

extension AppDelegate {
    func setupNotification(on application: UIApplication) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { granted, error in
            if let error = error {
                print("failed to request access")
                return
            }
            guard granted else {
                print("failed to gain acces")
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        
        let content = response.notification.request.content
        print("Title: \(content.title)")
        print("Body: \(content.body)")
        
        if let userInfo = content.userInfo as? [String: Any],
           let aps = userInfo["aps"] as? [String: Any] {
            print("aps: \(aps)")
        }
    }
}
