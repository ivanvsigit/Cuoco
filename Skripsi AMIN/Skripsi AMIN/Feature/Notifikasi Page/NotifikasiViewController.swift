//
//  NotifikasiViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 19/01/22.
//

import UIKit

class NotifikasiViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func scheduleNotification(body: String, titles:String) {
            
            var calendarComponents = DateComponents()
            calendarComponents.weekday = 5
            calendarComponents.hour = 00
            calendarComponents.second = 0
            calendarComponents.minute = 02
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = titles
            content.body = body
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "todoList"
            
            let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
