// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E





import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

struct UserProfileView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = ""
    @State private var showImagePicker: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var inputImage: UIImage?
    @State private var profileImage: Image?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            profileImage?
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding()
                .onTapGesture {
                    self.showActionSheet = true
                }

            if profileImage == nil {
                Button("Select Profile Picture") {
                    self.showActionSheet = true
                }
            }

            TextField("Enter Name, Other users can see your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                saveProfileData()
            }
        }
        .padding()
        .navigationBarTitle("User Profile", displayMode: .inline)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Select Photo"), message: Text("Choose a source"), buttons: [
                    .default(Text("Camera")) {
                        self.sourceType = .camera
                        self.showImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        self.sourceType = .photoLibrary
                        self.showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
            }
            .onAppear {
                loadProfileData()
            }
    }

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
        userViewModel.profileImage = inputImage 
        print("yes")
        uploadProfileImage(inputImage)
    }


    private func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images").child("\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Upload failed")
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("URL retrieval failed with error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                let ref = Database.database().reference().child("userProfiles").child(userId)
                ref.updateChildValues(["profileImageUrl": downloadURL.absoluteString]) { error, _ in
                    if let error = error {
                        print("Firebase database update error: \(error.localizedDescription)")
                        return
                    }
                    DispatchQueue.main.async {
                        // Update the profile image URL in UserViewModel
                        self.userViewModel.user.profileImageUrl = downloadURL.absoluteString
                        self.userViewModel.loadProfileImage() // Call loadProfileImage to update the image
                    }
                }
            }
        }
    }



    private func loadProfileData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("userProfiles").child(userId)

        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: Any] {
                self.name = value["name"] as? String ?? ""
                
                if let imageUrlString = value["profileImageUrl"] as? String, let url = URL(string: imageUrlString) {
                    loadImageFromUrl(url)
                }
            }
        })
    }

    private func loadImageFromUrl(_ url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }

    private func saveProfileData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("userProfiles").child(userId)
        
        ref.updateChildValues(["name": name])
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                print("Image has been picked.")
            } else {
                    print("No image found in picker.")
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}




