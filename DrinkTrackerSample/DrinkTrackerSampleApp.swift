//
//  DrinkTrackerSampleApp.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

@main
struct DrinkTrackerSampleApp: App {
    @State var state: AppState = .init(model: .previewData)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .onOpenURL(perform: handleURL)
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "widget",
              url.host == "stats",
              let offset = Int(url.lastPathComponent)
        else { return }
        
        let day = Date.day(offsetFromToday: offset)
        state.selected = day
    }
    
}
