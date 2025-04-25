//
//  ChooseDateView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 06/03/25.
//

import SwiftUI

struct ChooseDateView: View {
    @Binding var selectedDate: Date
    let title: String
    let dateRange: ClosedRange<Date>
    var displayedComponents: DatePicker<Text>.Components = [.date]
    @State var isDatePickerPresented: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
            
            Spacer()
            
            VStack {
                Text(selectedDate.formatted(.dateTime.day().month().year()))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)
                
                if displayedComponents.contains(.hourAndMinute) {
                    Text(selectedDate.formatted(.dateTime.hour().minute()))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
        .onTapGesture {
            isDatePickerPresented.toggle()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .stroke(Color.primaryColor, style: .init(lineWidth: 2))
        )
        .sheet(isPresented: $isDatePickerPresented) {
            DatePickerView(selectedDate: $selectedDate, dateRange: dateRange, displayedComponents: displayedComponents)
                .presentationDetents([.height(500)])
        }
    }
}

struct DatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    let dateRange: ClosedRange<Date>
    var displayedComponents: DatePicker<Text>.Components = [.date]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Done")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primaryColor)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding([.horizontal, .top], 32)
            
            DatePicker(selection: $selectedDate, in: dateRange, displayedComponents: displayedComponents) {}
                .labelsHidden()
                .datePickerStyle(.graphical)
                .padding()
        }
    }
}
