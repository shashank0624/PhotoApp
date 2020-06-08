//
//  NotificationPublisher.swift
//  DailySpend
//
//  Created by Shashank Panwar on 03/01/20.
//  Copyright © 2020 outect. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationPublisher : NSObject{
    
    static let shared = NotificationPublisher()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func sendNotifications(withIdentifier identifier : String, title : String, subTitle : String, body : String, isRepeatOn : Bool = false, delayInterval : Int, badge : Int?){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
        notificationContent.body = body
        
        let delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: isRepeatOn)
        
        if let badge = badge{
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            
        }
        
        notificationContent.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    
    func sendNotifications(withIdentifier identifier : String, title : String, subTitle : String, body : String, isRepeatOn : Bool = false, badge : Int?){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
        notificationContent.body = body
        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 08
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeatOn)
        
        if let badge = badge{
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            
        }
        
        notificationContent.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: dateTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    
    func sendNotificationsForMonthlyReport(withIdentifier identifier : String, title : String, subTitle : String, body : String, isRepeatOn : Bool = false, badge : Int?){
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
        notificationContent.body = body
        
        var dateComponents = DateComponents()
        dateComponents.day = 27
        dateComponents.hour = 22
        dateComponents.minute = 49
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeatOn)
        
        if let badge = badge{
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            
        }
        
        notificationContent.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: dateTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    
}

extension NotificationPublisher : UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification Received: \(notification.request.identifier)")
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("The Notification was dismissed")
            UIApplication.shared.applicationIconBadgeNumber -= 1
            completionHandler()
        
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification ")
            UIApplication.shared.applicationIconBadgeNumber -= 1
            completionHandler()
        default:
            print("The default case was called")
            completionHandler()
        }
    }
}
