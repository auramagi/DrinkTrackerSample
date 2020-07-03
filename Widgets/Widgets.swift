//
//  Widgets.swift
//  Widgets
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import WidgetKit
import SwiftUI

struct WidgetModel {
    let lastDate: Date?
    let stats: [Int]
}

extension WidgetModel {
    static var previewData: WidgetModel {
        WidgetModel(lastDate: Date().addingTimeInterval(-559), stats: [1, 2, 5])
    }
}

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry
    
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), model: loadModel())
        completion(entry)
    }
    
    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, model: loadModel())
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func loadModel() -> WidgetModel {
        let appModel = AppState().model!
        
        let widgetModel = WidgetModel(
            lastDate: appModel.entryLog.endDate,
            stats: [
                appModel.entryLog.amount(day: Date.day(offsetFromToday: 0)),
                appModel.entryLog.amount(day: Date.day(offsetFromToday: 1)),
                appModel.entryLog.amount(day: Date.day(offsetFromToday: 2))
            ]
        )
        
        return widgetModel
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    let model: WidgetModel
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WidgetsEntryView: View {
    var model: WidgetModel
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "drop.fill")
                        .font(Font.body.weight(.heavy))
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .frame(width: 60, height: 60)
                        .background(
                            ContainerRelativeShape()
                                .fill(Color(UIColor.systemFill))
                        )
                        .padding([.top, .horizontal], 11)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    HStack {
                        CellDetailView(model: model)
                        
                        Spacer()
                    }
                }
                .padding()
            }
            
            if widgetFamily == .systemMedium {
                Divider()
                
                VStack {
                    ForEach(model.stats.indices.reversed(), id: \.self) { index in
                        DailyStatsLinkView(offset: index, amount: model.stats[index])
                        
                        if index > 0 {
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.accentColor.opacity(0.10).blendMode(.hardLight))
    }
    
}

struct DailyStatsLinkView: View {
    let offset: Int
    let amount: Int
    
    var body: some View {
        Link(destination: URL(string: "widget://stats/\(offset)")!) {
            VStack {
                Text(Strings.glassCount(amount))
                    .font(.headline)
                
                Text(relativeDayLabel)
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var relativeDayLabel: String {
        switch offset {
        case 0: return "Today"
        case 1: return "Yesterday"
        case 2: return "1 day ago"
        default: return "\(offset) days ago"
        }
    }
}

struct CellDetailView: View {
    let model: WidgetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Water intake")
                .font(.system(.subheadline, design: .rounded))
            
            if let date = model.lastDate {
                // adding whitespace to line end prevent agressive truncating (beta 1 bug)
                Text("\(Text(date, style: .relative))                      ")
                    .font(.system(.headline, design: .rounded))
                
                Text(timestampString(date))
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(.secondary)
            } else {
                Text("Nothing logged so far")
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func timestampString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        df.doesRelativeDateFormatting = true
        
        return df.string(from: date)
    }
}

@main
struct Widgets: Widget {
    private let kind: String = "Widgets"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            WidgetsEntryView(model: entry.model)
                .widgetURL(URL(string: "widget://stats/0")!)
        }
        .configurationDisplayName("Reminder")
        .description("Your last drink, at a glance")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WidgetsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetsEntryView(model: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .background(Color("WidgetBackground")) // Color from Assets
                .environment(\.colorScheme, .light)
            
            WidgetsEntryView(model: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .background(Color("WidgetBackground")) // Color from Assets
                .environment(\.colorScheme, .dark)
            
            WidgetsEntryView(model: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .background(Color("WidgetBackground")) // Color from Assets
                .environment(\.colorScheme, .light)
            
            WidgetsEntryView(model: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .background(Color("WidgetBackground")) // Color from Assets
                .environment(\.colorScheme, .dark)
        }
    }
}
