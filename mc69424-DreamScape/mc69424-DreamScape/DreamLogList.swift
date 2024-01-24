// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E


import SwiftUI

struct DreamLogsListView: View {
    @ObservedObject var viewModel: DreamLogsViewModel
    @State private var showingAddDreamLogView = false
    let model = DreamLogModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.logs, id: \.id) { log in
                    NavigationLink(destination: DreamLogDetailView(log: log)) {
                        HStack {
                            Text(log.formattedDate)
                                .font(.custom("Cotane Beach", size: 16))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .onDelete(perform: deleteLog)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dream Log")
                        .font(.custom("Cotane Beach", size: 25))
                }
            }
            
            .navigationBarItems(trailing: Button(action: {
                self.showingAddDreamLogView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.primary)
            })
            .onAppear {
                model.fetchDreamLogs { logs in
                    viewModel.logs = logs
                }
            }
            .sheet(isPresented: $showingAddDreamLogView) {
                DreamLogView(onAdd: { newLog in
                    model.addDreamLog(newLog) { success in
                        if success {
                            viewModel.addLog(newLog)
                        }
                    }
                    self.showingAddDreamLogView = false
                })
            }
            Color.purple
            .ignoresSafeArea(.all)
        }
    }

    private func deleteLog(at offsets: IndexSet) {
        for index in offsets {
            let log = viewModel.logs[index]
            model.deleteDreamLog(log.id) { success in
                if success {
                    viewModel.logs.remove(atOffsets: offsets)
                }
            }
        }
    }
}

extension DreamLog {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date(timeIntervalSince1970: self.date))
    }
}



struct DreamLogDetailView: View {
    var log: DreamLog

    var body: some View {
        ZStack {
            Color.purple
            .ignoresSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(log.formattedDate)
                        .font(.custom("Cotane Beach", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                   
                    Text(log.icon)
                        .font(.custom("Cotane Beach", size: 50))
                        .foregroundColor(.primary)

                  
                    Text(log.description)
                        .font(.custom("Cotane Beach", size: 16))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dream Details")
                    .font(.custom("Cotane Beach", size: 25)) // Custom font for title
            }
        }
    }
}
