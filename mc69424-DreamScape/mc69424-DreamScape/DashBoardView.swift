// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
import SwiftUI

struct DashBoardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @State private var currentTab: Tab = .dashboard
    @StateObject var dreamLogsViewModel = DreamLogsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple
                .ignoresSafeArea(.all)
                
                VStack {
                    if currentTab == .dashboard {
                        HStack {
                            NavigationLink(destination: UserProfileView().environmentObject(userViewModel)) {
                                if let uiImage = userViewModel.profileImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else {
                                    Image("user")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                }
                            }
                            .padding(.leading)
                            Spacer()
                        }
                        .padding(.top, 50)
                    }
                    Spacer()
                    if currentTab == .dashboard {
                        NavigationLink(destination: ARWorldView().environmentObject(sharedViewModel)) {
                            Image("moong")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        TextField("", text: .constant("Tap the image to visit"))
                            .disabled(true)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .font(.custom("Cotane Beach", size: 25))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }

                    TabView(selection: $currentTab) {
                        DashboardContentView()
                            .tabItem {
                                Label("Dashboard", systemImage: "house")
                            }
                            .tag(DashBoardView.Tab.dashboard)

                        DreamLogsListView(viewModel: dreamLogsViewModel)
                            .tabItem {
                                Label("Dream Log", systemImage: "book.closed")
                            }
                            .tag(DashBoardView.Tab.dreamLog)

                        SettingsView().environmentObject(authViewModel)
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                            .tag(DashBoardView.Tab.settings)
                        
                        EmojiExplanationView()
                            .tabItem {
                                Label("Emojis", systemImage: "character.book.closed")
                            }
                            .tag(DashBoardView.Tab.explanation)
                    }
                    .onAppear() {
                        UITabBar.appearance().backgroundColor = .systemPurple
                    }
                    .tint(.black)
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarHidden(false)
            .onAppear {
                userViewModel.loadUserData()
            }
        }
    }
    
    enum Tab {
        case dashboard
        case dreamLog
        case settings
        case explanation
    }
}

struct DashboardContentView: View {
    var body: some View {
       
        VStack {
            Color.purple
            .ignoresSafeArea(.all)
        }
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
            .environmentObject(AuthViewModel())
            .environmentObject(UserViewModel())
    }
}



