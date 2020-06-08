//
//  AppDelegate.swift
//  PhotoApp
//
//  Created by Kirti Ahlawat on 06/06/20.
//  Copyright © 2020 Outect. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *){
            
        }else{
            let savedata =  UserDefaults.init(suiteName: "group.com.outect.photoApp")
            if savedata?.value(forKey: "img") != nil {
                let data = ((savedata?.value(forKey: "img")as! NSDictionary).value(forKey: "imgData")as! Data)
                let str = ((savedata?.value(forKey: "img")as! NSDictionary).value(forKey: "name")as! String)
                    if let mainVC = AppDelegate.getMainStoryboard().instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC{
                        mainVC.capturedImage = UIImage(data: data)
                        let navController = UINavigationController(rootViewController: mainVC)
                        navController.isNavigationBarHidden = true
                        let newWindow = window
                        newWindow?.rootViewController = navController
                        newWindow?.makeKeyAndVisible()
                        window = newWindow
                    }
        }
        }
        registerForRemoteNotifications(application: application)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: Custom Methods
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class func getMainStoryboard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }

}

//MARK:- NOTIFICATIONS CONFIGURATION
extension AppDelegate{
    private func registerForRemoteNotifications(application : UIApplication){
        let authOptions : UNAuthorizationOptions = [.sound,.alert,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if error != nil{
                print("Authorization UnSuccessfull")
            }else{
                print("Authorization Successful")
                
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications : \(error.localizedDescription)")
    }
    
    /**
      This function is added here only for debugging purposes, and can be removed if swizzling is enabled. If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
      the FCM registration token.
     */

    /**
     The registration token may change when:
       - The app is restored on a new device
       - The user uninstalls/reinstall the app
       - The user clears app data.
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceToken = deviceToken.reduce("", { $0 + String(format: "%02X", $1)})
        print("APNS TOKEN : \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    
    /*
     - This method is called in background if and only if "content-available": 1 is set in payload.
     - add "content-available": 1 in the payload, and remove the badge count from payload,
     - Badge count will increase when the app is in background,
     - Badge count will not updated if we swipe out the app.
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        print("APN recieved")
        // print(userInfo)
        
        let state = application.applicationState
        switch state {
            
        case .inactive:
            print("Inactive")
            
        case .background:
            print("Background")
            // update badge count here
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
            
        case .active:
            print("Active")
        default:
            print("Default case")
        }
        
        if let apsDict = userInfo["aps"] as? [String : Any]{
            if let alertMessage = apsDict["alert"] as? String{
                print("Alert Messages : \(alertMessage)")
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}
