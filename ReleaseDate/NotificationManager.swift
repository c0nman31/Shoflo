//
//  NotificationManager.swift
//  ReleaseDate
//
//  Created by Pete Connor on 5/14/20.
//  Copyright © 2020 Pete Connor. All rights reserved.
//

import UserNotifications

class NotificationManager {
    
    //Does this let the user tap the notification to be taken into the app?
    
    var isAuthorized: Bool? = nil
    
    let center = UNUserNotificationCenter.current()

    func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Success")
                self.isAuthorized = true
            } else {
                print("Notification Not Authorized")
                self.isAuthorized = false
            }
        }
        
        //center.delegate = self do i need this?
    }

    func scheduleNotification(myShow: MyShow, date: Date) {
        
        //once this works, i need to put date: Date parameter into this fuction (like in outfit tracker), so it fires off of the show next air date.
        
        requestNotificationAuthorization()
        
        let content = UNMutableNotificationContent()
        //pass these into the function as parameters
        content.title = "\(myShow.name ?? "Show Update")"
        content.body = "The first episode of a new season of \(myShow.name) is scheduled to air on \(date)"
        //content.categoryIdentifier = "alarm" //Do I need this?
        //content.userInfo = ["customData": "fizzbuzz"] //Do I need this?
        //content.sound = UNNotificationSound.default //Do I need this?

        
        let subtractedDate = Calendar.current.date(byAdding: .day, value: -5, to: date)
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: subtractedDate!)
        var dateComponents = DateComponents()
        dateComponents.year = calendarDate.year
        dateComponents.month = calendarDate.month
        dateComponents.day = calendarDate.day
        dateComponents.hour = 13
        dateComponents.minute = 47
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "\(myShow.id)", content: content, trigger: trigger)
        center.add(request) { (error: Error?) in
            
            if error == nil {
                print("Notification Scheduled", trigger ?? "Date Nil")
            } else {
                print("Error scheduling notification", error?.localizedDescription ?? "")
            }
        }
        
        let subtractedDate2 = Calendar.current.date(byAdding: .day, value: -5, to: date)
        let calendarDate2 = Calendar.current.dateComponents([.day, .year, .month], from: subtractedDate2!)
        var dateComponents2 = DateComponents()
        dateComponents2.year = calendarDate2.year
        dateComponents2.month = calendarDate2.month
        dateComponents2.day = calendarDate2.day
        dateComponents2.hour = 13
        dateComponents2.minute = 48
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false)
        let request2 = UNNotificationRequest(identifier: "\(myShow.id)" + "2", content: content, trigger: trigger2)
        center.add(request2) { (error: Error?) in
            
            if error == nil {
                print("Notification Scheduled", trigger ?? "Date Nil")
            } else {
                print("Error scheduling notification", error?.localizedDescription ?? "")
            }
        }
        
        let subtractedDate3 = Calendar.current.date(byAdding: .day, value: -5, to: date)
        let calendarDate3 = Calendar.current.dateComponents([.day, .year, .month], from: subtractedDate3!)
        var dateComponents3 = DateComponents()
        dateComponents3.year = calendarDate3.year
        dateComponents3.month = calendarDate3.month
        dateComponents3.day = calendarDate3.day
        dateComponents3.hour = 13
        dateComponents3.minute = 49
        
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents3, repeats: false)
        let request3 = UNNotificationRequest(identifier: "\(myShow.id)" + "3", content: content, trigger: trigger3)
        center.add(request3) { (error: Error?) in
            
            if error == nil {
                print("Notification Scheduled", trigger ?? "Date Nil")
                self.getPending()
            } else {
                print("Error scheduling notification", error?.localizedDescription ?? "")
            }
        }
    }
    
    func getPending() {
        self.center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("notreq: \(request.identifier)")
            }
        })
    }
    
}


/*
 
 let date = Date()

 let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
 let newDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
 print(calendarDate)
 print(newDate)
 print("Hello")
 
 */