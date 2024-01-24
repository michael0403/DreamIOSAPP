// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E



import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""

    var body: some View {
        VStack {
            Spacer()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 10)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Sign Up") {
                performSignUp()
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .cornerRadius(8.0)
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .font(.custom("Cotane Beach", size: 18))
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        )
    }

    var backButton: some View {
        HStack {
            Button(action: {
                // Add action to go back
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
    }

    private func performSignUp() {
        authViewModel.signUp(email: email, password: password) { success, error in
            if success {
                authViewModel.isLoggedIn = true
            } else {
                self.errorMessage = error ?? "An unknown error occurred"
                self.showingAlert = true
                self.alertTitle = "Sign Up Failed"
            }
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthViewModel())
    }
}







