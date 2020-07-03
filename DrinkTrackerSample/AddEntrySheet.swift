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
    
    @State var alertContent: ErrorAlertContent?
    @State var presAl: Bool = false
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
            
            if !canAdd {
                Text("\(Image(systemName: "xmark.octagon.fill")) Can not add in the future")
                    .foregroundColor(.red)
            }
            
            Button(
                action: { addEntry(); presentation.wrappedValue.dismiss() },
                label: { Text("Add")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .frame(width: 232)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                }
            ).disabled(!canAdd)
            
            Spacer()
        }
    }
    
    private func addEntry() {
        guard canAdd else { return }
        let entry = Entry(id: .init(), date: date, amount: amount)
        model.addEntry(entry)
    }
    
    private var canAdd: Bool {
        date < Date().dayRange().upperBound
    }
}
