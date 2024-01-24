// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E



import SwiftUI
import FirebaseAuth
import UserNotifications

enum ActiveAlert: Identifiable {
    case about, feedback, support
    var id: Self { self }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showNotificationExplanationAlert = false

    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @AppStorage("isNotificationEnabled") private var areNotificationsEnabled: Bool = false
    @State private var activeAlert: ActiveAlert?

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $isDarkModeEnabled) {
                    Text("Dark Mode")
                }
                .onChange(of: isDarkModeEnabled) {
                    AppearanceManager.updateAppearance(darkModeEnabled: isDarkModeEnabled)
                }

                Toggle(isOn: $areNotificationsEnabled) {
                    Text("Notifications")
                }
                .onChange(of: areNotificationsEnabled) {
                    UserDefaults.standard.set(areNotificationsEnabled, forKey: "isNotificationEnabled")
                    if areNotificationsEnabled {
                        NotificationManager.shared.requestNotificationPermissions()
                    } else {
                        NotificationManager.shared.cancelScheduledNotifications()
                    }
                }
                if areNotificationsEnabled {
                    Text("By toggling this, you allow us to send you a notification daily at 10:00 AM.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding([.leading, .bottom])
                }


                Button("About") {
                    activeAlert = .about
                }

                Button("Feedback") {
                    activeAlert = .feedback
                }

                Button("Support") {
                    activeAlert = .support
                }

                Button("Logout") {
                    authViewModel.signOut()
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .about, .feedback, .support:
                return handleStandardAlerts(alertType: alertType)
            }
        }
    }

    private func handleStandardAlerts(alertType: ActiveAlert) -> Alert {
        let (title, message) = titleAndMessageForAlert(alertType: alertType)
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
    }

    private func titleAndMessageForAlert(alertType: ActiveAlert) -> (String, String) {
        switch alertType {
        case .about:
            return ("About", "A dream-related app made by a sleep-deprived student.")
        case .feedback:
            return ("Feedback", "Send us your feedback!")
        case .support:
            return ("Support", "Need help? Contact us.")
        }
    }

    
}













