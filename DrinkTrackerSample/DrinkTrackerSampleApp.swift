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
                .onOpenURL(perform: handleURL)
                .errorAlert(content: $state.errorAlert) { [state] in
                    if state.model == nil {
                        fatalError("Critical app error")
                    }
                }
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
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "widget",
              url.host == "stats",
              let offset = Int(url.lastPathComponent)
        else { return }
        
        let day = Date.day(offsetFromToday: offset)
        state.model?.selected = day
    }
    
}

extension View {
    func errorAlert(content: Binding<ErrorAlertContent?>, dismissAction: (() -> Void)? = nil) -> some View {
        alert(item: content) { content in
            Alert(
                title: Text(content.title),
                message: Text(content.message),
                dismissButton: .default(Text("OK"), action: dismissAction)
            )
        }
    }
}
