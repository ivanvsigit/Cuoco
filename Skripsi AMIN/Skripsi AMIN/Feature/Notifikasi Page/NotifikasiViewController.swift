//
//  NotifikasiViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 19/01/22.
//

import UIKit
import UserNotifications

class NotifikasiViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // Notification center property
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        self.userNotificationCenter.delegate = self
//
//        self.requestNotificationAuthorization()
//        self.sendNotification()
//
//        scheduleNotification(body: "Wah ada menu baru nih!", titles: "Mari masak bersama")

        // Do any additional setup after loading the view.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func requestNotificationAuthorization() {
        // Code here
        
        // Auth options
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
        
        func requestNotificationAuthorization() {
            let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
            
            self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
                if let error = error {
                    print("Error: ", error)
                }
            }
        }
    }
//
//    func sendNotification() {
//        // Code here
//
//        // Create new notifcation content instance
//        let notificationContent = UNMutableNotificationContent()
//
//        // Add the content to the notification content
//        notificationContent.title = "Test"
//        notificationContent.body = "Test body"
//        notificationContent.badge = NSNumber(value: 3)
//
//        // Add an attachment to the notification content
//        if let url = Bundle.main.url(forResource: "dune",
//                                        withExtension: "png") {
//            if let attachment = try? UNNotificationAttachment(identifier: "dune",
//                                                                url: url,
//                                                                options: nil) {
//                notificationContent.attachments = [attachment]
//            }
//        }
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                                                        repeats: false)
//
//        let request = UNNotificationRequest(identifier: "testNotification",
//                                            content: notificationContent,
//                                            trigger: trigger)
//
//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }
//
    

    func scheduleNotification(body: String, titles:String) {
        
        var calendarComponents = DateComponents()
            calendarComponents.weekday = 7
            calendarComponents.hour = 23
            calendarComponents.second = 00
            calendarComponents.minute = 50

        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: true)

        let content = UNMutableNotificationContent()
            content.title = titles
            content.body = body
            content.sound = UNNotificationSound.default
//            content.badge = NSNumber(value: 5)
//            content.categoryIdentifier = "todoList"

            let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().delegate = self
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }

}
