//
//  Widgets.swift
//  Widgets
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "drop.fill")
                    .font(Font.body.weight(.heavy))
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .padding([.top, .horizontal])
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    CellDetailView(timestamp: entry.date)
                    
                    Spacer()
                }
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
    }
}

struct CellDetailView: View {
    let timestamp: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Water intake")
                .font(.system(.subheadline, design: .rounded))
        
            // adding whitespace to line end prevent agrressive truncating (beta 1 bug)
            Text("\(Text(timestamp, style: .relative))     ")
                .font(.system(.headline, design: .rounded))
            
            Text(timestamp, style: .time)
                .font(.system(.caption, design: .rounded))
                .bold()
                .imageScale(.small)
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
        }
    }
}

@main
struct Widgets: Widget {
    private let kind: String = "Widgets"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetsEntryView(entry: .init(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .light)
            
            
            WidgetsEntryView(entry: .init(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)
        }
    }
}
