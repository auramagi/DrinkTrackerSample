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
        }
    }
}
