// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var authenticationFailed: Bool = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                DashBoardView().environmentObject(authViewModel)
            } else {
                loginView
            }
        }
        .onAppear {
            authViewModel.onLogout = {
                self.email = ""
                self.password = ""
            }
        }
        .onAppear {
            AppearanceManager.updateAppearance(darkModeEnabled: UserDefaults.standard.bool(forKey: "isDarkModeEnabled"))
        }
    }

    var loginView: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("loginpic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)

                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                    .font(.custom("Cotane Beach", size: 16))

                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                    .font(.custom("Cotane Beach", size: 16))

                if authenticationFailed {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                // Login button
                Button(action: {
                    authViewModel.signIn(email: email, password: password) { success, error in
                        if success {
                            authenticationFailed = false
                        } else {
                            authenticationFailed = true
                            errorMessage = error ?? "An error occurred"
                        }
                    }
                }) {
                    Text("Log In")
                        .dreamButtonStyle()
                }
                .padding()
                NavigationLink(destination: SignUpView().environmentObject(authViewModel)) {
                    Text("Sign Up")
                        .dreamButtonStyle()
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing) .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct DreamButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(8.0)
            .shadow(radius: 10)
            .font(.custom("Cotane Beach", size: 16))
                                 
    }
}

extension View {
    func dreamButtonStyle() -> some View {
        self.modifier(DreamButtonStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel())
    }
}










