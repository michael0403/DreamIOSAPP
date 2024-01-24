// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E




import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftUI
import UIKit
import Firebase

struct UserModel {
    var name: String
    var profileImageUrl: String
}

class UserViewModel: ObservableObject {
    @Published var user: UserModel = UserModel(name: "", profileImageUrl: "")
    @Published var profileImage: UIImage? = UIImage(named: "user")
    
    func updateProfileImageUrl(_ url: String) {
        DispatchQueue.main.async {
            self.user.profileImageUrl = url
            self.loadProfileImage()
        }
    }

    func loadProfileImage() {
        print("Current profileImageUrl: \(self.user.profileImageUrl)")
        guard !self.user.profileImageUrl.isEmpty, let url = URL(string: self.user.profileImageUrl) else {
            self.profileImage = UIImage(named: "user") // Fallback to default image
            print("fallback")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.profileImage = downloadedImage
                    print("yes") // Debug
                }
            } else {
                print("Downloaded data is not an image or is nil")
            }
        }.resume()
    }
    init() {
        loadUserData()
    }
    
    func loadUserData() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("userProfiles").child(userId)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? [String: Any],
                   let imageUrlString = value["profileImageUrl"] as? String {
                    self.user.profileImageUrl = imageUrlString
                    self.loadProfileImage()  // Load the image from the URL
                }
            })
        }
}

