//
//  GenderPickerSheet.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.08.2025.
//

import SwiftUI

struct GenderPickerSheet: View {
    @Binding var selectedGender: String
    @Binding var showGenderPicker: Bool
    let genderOptions: [String]
    
    var body: some View {
        ZStack {
            Color.lightBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Done") {
                        showGenderPicker = false
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .padding()
                }
                .background(Color.lightBg)
                
                Spacer().frame(height: 40)
                
                VStack(spacing: 0) {
                    ForEach(genderOptions, id: \.self) { option in
                        Button(action: {
                            selectedGender = option
                        }) {
                            HStack {
                                Text(option)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedGender == option ? .white : .gray)
                                    .padding(.vertical, 12)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .background(
                            selectedGender == option ?
                            Color.gray.opacity(0.3) : Color.clear
                        )
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                    }
                }
                
                Spacer()
            }
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}
