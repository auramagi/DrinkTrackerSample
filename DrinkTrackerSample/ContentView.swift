//
//  ContentView.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

struct ContentModel {
    let entries: [Date]
    
    var startDate: Date {
        entries.min() ?? Date()
    }
    
    func entries(day: Date) -> [Date] {
        let range = day.dayRange()
        return entries.filter { range.contains($0) }
    }
}

extension ContentModel {
    static var previewData: ContentModel {
        ContentModel(entries: [
            sampleData(day: Date.day(offsetFromToday: 0), sampleCount: 3),
            sampleData(day: Date.day(offsetFromToday: 1), sampleCount: 5),
            sampleData(day: Date.day(offsetFromToday: 2), sampleCount: 6),
            sampleData(day: Date.day(offsetFromToday: 3), sampleCount: 6),
            sampleData(day: Date.day(offsetFromToday: 4), sampleCount: 5),
            sampleData(day: Date.day(offsetFromToday: 5), sampleCount: 7),
        ].flatMap({ $0 }))
    }
    
    private static func sampleData(day: Date, sampleCount: Int) -> [Date] {
        (0..<sampleCount).map { _ in
            Calendar.current.date(
                bySettingHour: (2...11).randomElement()!,
                minute: (0...59).randomElement()!,
                second: 0,
                of: day
            )!
        }
    }
}

struct ContentView: View {
    let model: ContentModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
                    ForEach(Date().days(enumeratingDownTo: model.startDate), id: \.self) {
                        day in
                        NavigationLink(destination: DayView(model: model, day: day)) {
                            DayGridItem(model: model, day: day)
                        }
                    }
                }
                .padding()
            }
            .background(Color("GridBackground"))
            .navigationTitle("Drink tracker")
        }
    }
    
}

struct DayGridItem: View {
    let model: ContentModel
    let day: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("GridItemBackground"))
            
            VStack {
                Text("\(model.entries(day: day).count) Glasses")
                        .font(.headline)
                
                Text(DayFormat.dateFormatter.string(from: day))
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 120)
    }
}

struct DayView: View {
    let model: ContentModel
    let day: Date
    
    
    var body: some View {
        List {
            ForEach(model.entries(day: day).sorted(by: >), id: \.self) { entry in
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
        .navigationTitle(DayFormat.dateFormatter.string(from: day))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(model: .previewData)
                .environment(\.colorScheme, .light)
            
            ContentView(model: .previewData)
                .environment(\.colorScheme, .dark)
        }
    }
}
