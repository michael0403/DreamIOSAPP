//
// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    var onLogout: (() -> Void)?

    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Firebase signIn logic here
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.isLoggedIn = true
                completion(true, nil)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            onLogout?()
        } catch let signOutError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.isLoggedIn = true
                completion(true, nil)
            }
        }
    }

}

