//
//  DatePickerSheet.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.08.2025.
//

import SwiftUI


struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        ZStack {
            Color.lightBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section with Done button
                HStack {
                    Spacer()
                    Button("Done") {
                        showDatePicker = false
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .padding()
                }
                .background(Color.lightBg)
                
                Spacer().frame(height: 40)
                
                // Date Picker
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorScheme(.dark)
                    .scaleEffect(1.1)
                
                Spacer()
            }
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}
