//
// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
//
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Record Your Dream"
        content.body = "Don't forget to record what you dreamt about last night!"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10  // 10:00 AM
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyDreamReminder",
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Handle any errors
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily dream recording reminder scheduled.")
            }
        }
    }

    func cancelScheduledNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyDreamReminder"])
        print("Daily dream recording reminder cancelled.")
    }
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    print("Notifications permission granted.")
                    NotificationManager.shared.scheduleReminderNotification()
                    UserDefaults.standard.set(true, forKey: "isNotificationEnabled")
                } else {
                    print("Notifications permission denied.")
                    NotificationManager.shared.cancelScheduledNotifications()
                    UserDefaults.standard.set(false, forKey: "isNotificationEnabled")
                }
            }
        }
    }
}



