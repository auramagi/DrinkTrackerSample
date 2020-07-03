//
//  AddEntrySheet.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import SwiftUI

struct AddEntrySheet: View {
    @State var date: Date
    @State var amount: Int = 1
    
    @EnvironmentObject var model: AppModel
    @Environment(\.presentationMode) var presentation
    
    @ViewBuilder
    var body: some View {
        VStack {
            DatePicker(selection: $date, label: { Text("Date") })
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 450)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            Stepper(value: $amount, in: 1...10, step: 1, label: { Text(Strings.glassCount(amount)).font(.headline) })
                .frame(width: 232)
            
            Spacer()
            
            Button(
                action: { addEntry(); presentation.wrappedValue.dismiss() },
                label: { Text("Add")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .frame(width: 232)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                }
            )
            
            Spacer()
        }
    }
    
    private func addEntry() {
        let entry = Entry(id: .init(), date: date, amount: amount)
        model.addEntry(entry)
    }
}
