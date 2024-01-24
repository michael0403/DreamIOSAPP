//
// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
//

import UIKit

class AppearanceManager {
    static func updateAppearance(darkModeEnabled: Bool) {
        let style: UIUserInterfaceStyle = darkModeEnabled ? .dark : .light
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = style
        }
    }
}
