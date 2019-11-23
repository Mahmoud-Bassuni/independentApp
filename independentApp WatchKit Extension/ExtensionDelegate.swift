//
//  ExtensionDelegate.swift
//  independentApp WatchKit Extension
//
//  Created by Bassuni on 11/23/19.
//  Copyright © 2019 futureface. All rights reserved.
//

import WatchKit
import UserNotifications
class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        let center = UNUserNotificationCenter.current()
                     center.delegate = self
      //  WKExtension.shared().registerForRemoteNotifications()
      //  setUpNotificationPreferences()
        setUpNotificationPreferences()
        addLocalNotification()
    }

    func addLocalNotification()  {
       // Configure the notification's payload.
       let content = UNMutableNotificationContent()
        content.title = "hello" //NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = "body" //NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default

       // Deliver the notification in five seconds.
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
       let center = UNUserNotificationCenter.current()
       center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
            }
       }
    }
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data)

    {
        print(deviceToken.base64EncodedString())

    }
     func didFailToRegisterForRemoteNotificationsWithError(_ error: Error)

    {

    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
extension ExtensionDelegate : UNUserNotificationCenterDelegate{
    // recive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
        // SoundManagement.shared.playSound()
    }
    func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        //SoundManagement.shared.playSound()
    }

    // recive notification with data
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any],
                                      fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void)
    {


        completionHandler(.newData)
    }



    func application(_ notification: UNNotification, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void) {

    }

    // user open notification
    // MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("\(#function)")
        completionHandler()
    }


    func setUpNotificationPreferences() {




        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
           if let theError = error {
               NSLog("\(#function) error when request localNotification \(theError.localizedDescription)")
           } else {
               if !granted {
                   NSLog("\(#function) Warning local notification not granted")
               }
           }

        })

        let notificationCategory = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [],  options: [])
        let categories: Set = [notificationCategory]
        UNUserNotificationCenter.current().setNotificationCategories(categories)

        }
    }



