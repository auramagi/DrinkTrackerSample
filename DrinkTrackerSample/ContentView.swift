//
//  ContentView.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    
    @State var isShowingWidgetSelectedDate: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
                    ForEach(Date().days(enumeratingDownTo: model.entryLog.startDate ?? Date()), id: \.self) {
                        day in
                        NavigationLink(
                            destination: DayView(day: day).environmentObject(model),
                            tag: day,
                            selection: $model.selected,
                            label: { DayGridItem(day: day, model: model.entryLog) }
                        )
                    }
                }
                .padding()
                
                if let selected = model.selected {
                    NavigationLink(
                        destination: DayView(day: selected).environmentObject(model),
                        isActive: $isShowingWidgetSelectedDate,
                        label: { EmptyView() }
                    ).hidden()
                }
                
            }
            .onReceive(model.$selected) { date in
                isShowingWidgetSelectedDate = date != nil
            }
            .background(Color("GridBackground"))
            .navigationTitle("Drink tracker")
            
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
        }
        .sheet(isPresented: $model.isAddingEntry, content: makeSheetContent)
    }
    
    private func makeSheetContent() -> some View {
        AddEntrySheet(date: model.selected ?? Date())
            .environmentObject(model)
    }
    
}

struct DayGridItem: View {
    let day: Date
    let model: EntryLog
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("GridItemBackground"))
            
            VStack {
                Text(Strings.glassCount(model.amount(day: day)))
                        .font(.headline)
                
                Text(DayFormat.dateFormatter.string(from: day))
                    .font(.system(.caption, design: .rounded)).bold()
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 120)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let model: AppModel = .init(entryLog: .previewData)
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(model)
                .environment(\.colorScheme, .light)
            
            ContentView()
                .environmentObject(model)
                .environment(\.colorScheme, .dark)
        }
    }
}
