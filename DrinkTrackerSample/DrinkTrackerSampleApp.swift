//
//  DrinkTrackerSampleApp.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

@main
struct DrinkTrackerSampleApp: App {
    @State var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            windowContent
                .alert(item: $state.errorAlert, content: makeErrorAlert)
                .onOpenURL(perform: handleURL)
        }
    }
    
    @ViewBuilder
    private var windowContent: some View {
        if let model = state.model {
            ContentView().environmentObject(model)
        } else {
            EmptyView()
        }
    }
    
    private func makeErrorAlert(content: ErrorAlertContent) -> Alert {
        Alert(
            title: Text(content.title),
            message: Text(content.message),
            dismissButton: .default(Text("OK"), action: { [state] in
                if state.model == nil {
                    fatalError("Critical app error")
                }
            })
        )
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "widget",
              url.host == "stats",
              let offset = Int(url.lastPathComponent)
        else { return }
        
        let day = Date.day(offsetFromToday: offset)
        state.model?.selected = day
    }
    
}
