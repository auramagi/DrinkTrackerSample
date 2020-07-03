//
//  DayView.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

struct DayView: View {
    let day: Date
    
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        List {
            ForEach(model.entryLog.entries(day: day).sorted(by: { $0.date > $1.date }), id: \.date) { entry in
                HStack {
                    Text(Strings.glassCount(entry.amount))
                        .font(.headline).bold()
                    
                    Spacer()
                    
                    Text(DayFormat.timeFormatter.string(from: entry.date))
                        .font(.system(.caption, design: .rounded)).bold()
                        .foregroundColor(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { model.isAddingEntry = true }) {
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
    static let model: AppModel = .init(entryLog: .previewData)
    static var previews: some View {
        Group {
            DayView(day: Date())
                .environmentObject(model)
                .environment(\.colorScheme, .light)
            
            DayView(day: Date())
                .environmentObject(model)
                .environment(\.colorScheme, .dark)
        }
    }
}
