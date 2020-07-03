//
//  DayView.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

struct DayView: View {
    let day: Date
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        List {
            ForEach(state.model.entries(day: day).sorted(by: >), id: \.self) { entry in
                HStack {
                    Text("1 glass")
                        .font(.headline).bold()
                    
                    Spacer()
                    
                    Text(DayFormat.timeFormatter.string(from: entry))
                        .font(.system(.caption, design: .rounded)).bold()
                        .foregroundColor(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { state.isAddingEntry = true }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        
                        Text("Add a glass")
                    }
                }
            }
        }
        .navigationTitle(DayFormat.dateFormatter.string(from: day))
    }
}

struct DayView_Previews: PreviewProvider {
    static let state: AppState = .init(model: .previewData)
    static var previews: some View {
        Group {
            DayView(day: Date())
                .environmentObject(state)
                .environment(\.colorScheme, .light)
            
            DayView(day: Date())
                .environmentObject(state)
                .environment(\.colorScheme, .dark)
        }
    }
}
