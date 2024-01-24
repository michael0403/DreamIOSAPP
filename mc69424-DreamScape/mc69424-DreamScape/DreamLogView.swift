// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E


import SwiftUI

struct DreamLogView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedViewModel: SharedViewModel
    var onAdd: (DreamLog) -> Void
    @State private var description = ""
    @State private var showAlert = false
    
    public var dreamLogModel = DreamLogModel()

    var body: some View {
        ZStack {
            Color.purple.opacity(0.6)
            .ignoresSafeArea(.all)
            NavigationView {
                Form {
                    Text("Emoji that describes your dream:")
                        .font(.custom("Cotane Beach", size: 20))
                        .foregroundColor(.secondary)
                        .padding(.top, 10)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                        ForEach(sharedViewModel.emojiChoices, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .onTapGesture {
                                    sharedViewModel.selectedEmoji = emoji
                                }
                                .border(Color.blue, width: sharedViewModel.selectedEmoji == emoji ? 3 : 0)
                        }
                    }
                    .padding(.bottom, 20)

                    Text("Describe Your Dream:")
                        .font(.custom("Cotane Beach", size: 20))
                        .foregroundColor(.secondary)
                        .padding(.top, 10)

                    TextEditor(text: $description)
                        .font(.custom("Cotane Beach", size: 16))
                        .foregroundColor(.primary)
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .frame(height: 300)

                    Button(action: {
                        dreamLogModel.canCreateNewLog { canCreate in
                            if canCreate {
                                guard let selectedEmoji = sharedViewModel.selectedEmoji else {
                                    return
                                }

                                let newLog = DreamLog(date: Date().timeIntervalSince1970, description: description, icon: selectedEmoji)
                                dreamLogModel.addDreamLog(newLog) { success in
                                    if success {
                                        onAdd(newLog)
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    showAlert = true
                                }
                            }
                        }
                    }) {
                        Text("Add Dream Log")
                            .font(.custom("Cotane Beach", size: 16))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Emoji Meanings")
                            .font(.custom("Cotane Beach", size: 35))
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text("Only one dream log can be created per day.")
            )
        }
    }
}









