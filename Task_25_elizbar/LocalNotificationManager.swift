//
//  LocalNotificationManager.swift
//  Task_25_elizbar
//
//  Created by alta on 8/27/22.
//

import Foundation
import UserNotifications
import UIKit

struct LocalNotification {
    var id: String
    var title:String
    var body:String
}
enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}


struct LocalNotificationManager {
    static private var notifications = [LocalNotification]()
    
    static private func requestPermission() -> Void{
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert,.badge,.alert]) { granted, error in
                if granted == true && error == nil {
                    print("permission granted")
                }
            }
    }
    
    
    static private func addNotification(title: String, body: String) -> Void {
        notifications.append(LocalNotification(id: UUID().uuidString, title: title, body: body))
    }
    
    
    static private func scheduleNotification(_ durationInSeconds: Int,repeats: Bool , userInfo: [AnyHashable:Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.defaultRingtone
            content.badge = NSNumber( value : UIApplication.shared.applicationIconBadgeNumber + 1)
            content.userInfo = userInfo
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(durationInSeconds), repeats: repeats)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request){error in
                guard error == nil else { return }
                print("soon presenting notification  \(notification.id)")
                
            }
        }
        notifications.removeAll()
    }
    
    static func scheduleNotifications(_ duration: Int, ofType:
                                      LocalNotificationDurationType, repeats: Bool ,userInfo: [AnyHashable : Any]) {
        var seconds = 0
        switch ofType{
        case .seconds :
            seconds = duration
        case .minutes :
            seconds = duration * 60
        case .hours :
            seconds = duration * 3600
        case .days :
            seconds = duration * 86400
            
        }
        scheduleNotification(seconds, repeats: repeats, userInfo: userInfo)
    }
    
    static func setNotification(_ duration: Int, type:
                                LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo : [AnyHashable : Any]){
        requestPermission()
        addNotification(title: title, body: body)
        scheduleNotifications(duration, ofType: type, repeats: repeats, userInfo: userInfo)
    }
    
}
