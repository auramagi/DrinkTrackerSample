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
            ForEach(model.model.entries(day: day).sorted(by: >), id: \.self) { entry in
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
    static let model: AppModel = .init(model: .previewData)
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
