//
//  Model.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import Foundation
import Combine
import WidgetKit

struct Entry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Int
}

struct EntryLog: Codable {
    var entries: [Entry]
    
    var startDate: Date? {
        entries
            .map { $0.date }
            .min()
    }
    
    var endDate: Date? {
        entries
            .map { $0.date }
            .max()
    }
    
    func entries(day: Date) -> [Entry] {
        let range = day.dayRange()
        return entries
            .filter { range.contains($0.date) }
    }
    
    func amount(day: Date) -> Int {
        entries(day: day).reduce(into: 0) { $0 += $1.amount }
    }
}

class AppState: ObservableObject {
    let model: AppModel?
    @Published var errorAlert: ErrorAlertContent?
    
    init() {
        if let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.me.apurin.DrinkTrackerSample") {
            do {
                try self.model = AppModel(folder: folder, ignoringCorruptedDatabase: false)
            } catch {
                self.model = nil
                self.errorAlert = error.asErrorAlert(title: "Database Error")
            }
        } else {
            self.model = nil
            self.errorAlert = ErrorAlertContent(title: "Database Error", message: "Can not find document directory")
        }
    }
}

class AppModel: ObservableObject {
    private let persistance: Persistance<EntryLog>
    private var cancellables: [AnyCancellable] = []
    private let workQueue: DispatchQueue = DispatchQueue(label: "EntryStore.WorkQueue", qos: .userInitiated)
    
    @Published private(set) var entryLog: EntryLog
    @Published private(set) var persistanceSyncStatus: SyncStatus = .synced
    
    @Published var selected: Date?
    @Published var isAddingEntry: Bool = false
    
    enum SyncStatus {
        case synced
        case inProgress
        case error(Error)
    }
    
    init(entryLog: EntryLog) {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.persistance = Persistance(folder: folder, fileName: "entries.json", defaultValue: EntryLog(entries: []))
        self.entryLog = entryLog
    }
       
    init(folder: URL, ignoringCorruptedDatabase: Bool) throws {
        self.persistance = Persistance(folder: folder, fileName: "entries.json", defaultValue: EntryLog(entries: []))
        do {
            self.entryLog = try persistance.load()
        } catch {
            if ignoringCorruptedDatabase {
                self.entryLog = EntryLog(entries: [])
            } else {
                throw error
            }
        }
        
        _entryLog.projectedValue
            .debounce(for: 1, scheduler: workQueue)
            .sink { [weak self] lists in
                self?.receiveSyncUpdate(.synced)
                do {
                    try self?.persistance.save(lists)
                    self?.receiveSyncUpdate(.inProgress)
                } catch {
                    self?.receiveSyncUpdate(.error(error))
                }
            }
            .store(in: &cancellables)
    }
    
    private func receiveSyncUpdate(_ status: SyncStatus) {
        DispatchQueue.main.async {
            self.persistanceSyncStatus = status
        }
    }
    
    func addEntry(_ entry: Entry) {
        entryLog.entries.append(entry)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func deleteEntries(ids: [UUID]) {
        entryLog.entries.removeAll { ids.contains($0.id) }
    }
    
}

fileprivate struct Persistance<T: Codable> {
    let folder: URL
    let fileName: String
    let defaultValue: T
    
    func load() throws -> T {
        guard FileManager.default.fileExists(atPath: folder.appendingPathComponent(fileName).path) else { return defaultValue }
        let data = try Data(contentsOf: folder.appendingPathComponent(fileName))
        return try JSONDecoder()
            .decode(T.self, from: data)
    }
    
    func save(_ content: T) throws {
        try JSONEncoder()
            .encode(content)
            .write(to: folder.appendingPathComponent(fileName))
    }
}

extension String: Error { }

extension Error {
    func asErrorAlert(title: String) -> ErrorAlertContent {
        ErrorAlertContent(title: title, message: "\(self)")
    }
}

struct ErrorAlertContent: Identifiable {
    let id: UUID = .init()
    let title: String
    let message: String
}




extension EntryLog {
    static var previewData: EntryLog {
        EntryLog(entries: [
            sampleData(day: Date.day(offsetFromToday: 0), sampleCount: 3),
            sampleData(day: Date.day(offsetFromToday: 1), sampleCount: 5),
            sampleData(day: Date.day(offsetFromToday: 2), sampleCount: 6),
            sampleData(day: Date.day(offsetFromToday: 3), sampleCount: 6),
            sampleData(day: Date.day(offsetFromToday: 4), sampleCount: 5),
            sampleData(day: Date.day(offsetFromToday: 5), sampleCount: 7),
        ].flatMap({ $0 }))
    }
    
    private static func sampleData(day: Date, sampleCount: Int) -> [Entry] {
        (0..<sampleCount).map { _ in
            Entry(
                id: .init(),
                date: Calendar.current.date(
                    bySettingHour: (2...11).randomElement()!,
                    minute: (0...59).randomElement()!,
                    second: 0,
                    of: day
                )!,
                amount: (1...2).randomElement()!
            )
        }
    }
}

enum Strings {
    static func glassCount(_ amount: Int) -> String {
        if amount == 1 {
            return "1 glass"
        } else {
            return "\(amount) glasses"
        }
    }
}
