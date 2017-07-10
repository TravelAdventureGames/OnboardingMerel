//
//  NotificationManager.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 05-07-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UserNotifications


//Een enum om de verschillende notifications te kunnen setten. Er wordt periodiek (eens per maand?) een notidicatie gestuurd. De title en body ervan worden bepaald door de verschillende cases die worden gedefinieerd.

enum LocalNotification {

    case Regular
    case DidNotUseForALongTime
    
    var title: String {
        switch self {
        case .Regular:
            return "Tap-app: Mothly update"
        case .DidNotUseForALongTime:
            return "Tapp-app"
        }
    }
    
    var body: String {
        switch self {
        case .Regular:
            return getRegularNotificationText()
        case .DidNotUseForALongTime:
            return "Je hebt de tap-app al een tijdje niet gebruikt. Probeer het nog eens, tappen helpt echt!"
        }
    }
    // Set deze door de huidige gemiddelde score te delen door de gemiddelde vorige score van alle tapsessies. deze moeten uit coreData worden gehaald. Voor nu zijn tijdelijke vaste scores toegekend. In deze
    
    func getRegularNotificationText() -> String {
        let previousAverageScore = 6.1 //todo: set uit coredata
        let currentAverageScore = 4.8 //todo: set uit coredata
        let percentageImproved = round(((previousAverageScore - currentAverageScore) / previousAverageScore) * 1000) / 10 //geeft het percentage voor-of achteruitgang tov vorige gemiddelde score
        print(percentageImproved)
        var text = ""
        if percentageImproved > 0 {
            text = "Je voelt je deze maand \(percentageImproved) % beter dan de vorige maand. Dat moet een heerlijk gevoel zijn. Ga vooral door!"
        } else {
            text = "Je voelt je deze maand \(percentageImproved) % slechter dan de vorige maand. Maar geef nu niet op, blijf je sessies doen!"
        }
        return text
    }
    // Todo: Create a counter (userdefaults?) to count the number of sessions done
    
    func getNumberOfSessionsInMonth() -> Int {
        return 3
    }
    
}

struct NotificationFireDate {
    static let nextDay: TimeInterval = 85_000
    static let nextWeek: TimeInterval = 604_000
    static let nextMonth: TimeInterval = 2416_000
}

// MARK: The class schedules and presents local notifications every week / month / etc. (whatever we decide to do). The content of the message is created by the LocalNotifcation enum. The current case is created by the getNotificationCase() function. Tested and worked after authorization.

class NoticationManager: NSObject {
    
    // Provides logic to determine the case which sets the notication, Can be expanded if needed.
    func getNotificationCase() -> LocalNotification {
        let numberOfSessionInMonth = 1 //get from userdefaults or coredata?
        switch numberOfSessionInMonth {
        case 0:
            return .DidNotUseForALongTime
        default:
            return .Regular
        }
        
        
    }
    
    func pushLocalNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
        
                    self.scheduleLocalNotification(notificationCase: self.getNotificationCase())
                })
            case .authorized:

                self.scheduleLocalNotification(notificationCase: self.getNotificationCase())
                
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    // Asks for authorization the first time the app is used
    private func requestAuthorization(completionHandler: @escaping (_ succes: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (succes, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(succes)
        }
    }
    // Schedules the next notification with a title, subtitle, body and sound
    private func scheduleLocalNotification(notificationCase: LocalNotification) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notificationCase.title
        notificationContent.body = notificationCase.body
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: NotificationFireDate.nextMonth, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: "Notification_of_the_month", content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
        
    }
    
}
