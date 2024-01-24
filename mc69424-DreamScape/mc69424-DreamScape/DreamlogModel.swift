// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E


import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct DreamLog: Identifiable, Codable {
    var id: String = UUID().uuidString
    var date: TimeInterval
    var description: String
    var icon: String
   
}

class DreamLogModel {
    private var ref = Database.database().reference()
    
    
    func fetchDreamLogs(completion: @escaping ([DreamLog]) -> Void) {
        ref.child("dreamLogs").queryOrdered(byChild: "date").observeSingleEvent(of: .value) { snapshot in
            var newItems: [DreamLog] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let log = DreamLog(snapshot: snapshot) {
                    newItems.append(log)
                }
            }
            completion(newItems)
        }
    }
    func canCreateNewLog(completion: @escaping (Bool) -> Void) {
        ref.child("dreamLogs").queryOrdered(byChild: "date").queryLimited(toLast: 1).observeSingleEvent(of: .value) { snapshot in
            if let lastLogSnapshot = snapshot.children.allObjects.first as? DataSnapshot,
               let lastLog = DreamLog(snapshot: lastLogSnapshot),
               Calendar.current.isDateInToday(Date(timeIntervalSince1970: lastLog.date)) {
                completion(false) // A log exists for today
            } else {
                completion(true) // No log for today, can create new one
            }
        }
    }

    func addDreamLog(_ log: DreamLog, completion: @escaping (Bool) -> Void) {
        let logRef = self.ref.child("dreamLogs").child(log.id)
        logRef.setValue(log.toDictionary()) { error, _ in
            if error == nil {
                self.lastLogDate = Date() // Update lastLogDate only if there's no error
            }
            completion(error == nil)
        }
    }

    func deleteDreamLog(_ id: String, completion: @escaping (Bool) -> Void) {
        ref.child("dreamLogs").child(id).observeSingleEvent(of: .value) { snapshot in
            if let log = DreamLog(snapshot: snapshot),
               Calendar.current.isDateInToday(Date(timeIntervalSince1970: log.date)) {
                self.lastLogDate = nil
            }

            self.ref.child("dreamLogs").child(id).removeValue { error, _ in
                completion(error == nil)
            }
        }
    }

    private var lastLogDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastLogDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastLogDate")
        }
    }
}

class DreamLogsViewModel: ObservableObject {
    @Published var logs: [DreamLog] = []
    
    
    func addLog(_ log: DreamLog) {
        logs.append(log)
    }
}

extension DreamLog {
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let date = value["date"] as? TimeInterval,
            let description = value["description"] as? String,
            let icon = value["icon"] as? String else {
                return nil
        }

        self.id = snapshot.key
        self.date = date
        self.description = description
        self.icon = icon
        
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "date": date,
            "description": description,
            "icon": icon
        ]
    }
}


