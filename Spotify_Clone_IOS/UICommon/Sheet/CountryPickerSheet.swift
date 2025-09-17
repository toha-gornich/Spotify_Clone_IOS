//
//  CountryPickerSheet.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.09.2025.
//

import SwiftUI

struct CountryPickerSheet: View {
    @Binding var selectedCountry: String
    @Binding var showCountryPicker: Bool
    let countryOptions: [String]
    
    var body: some View {
        ZStack {
            Color.lightBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Done") {
                        showCountryPicker = false
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .padding()
                }
                .background(Color.lightBg)
                
                Spacer().frame(height: 40)
                
            
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(countryOptions, id: \.self) { option in
                            Button(action: {
                                selectedCountry = option
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedCountry == option ? .white : .gray)
                                        .padding(.vertical, 12)
                                    
                                    Spacer()
                                    
                                    if selectedCountry == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .background(
                                selectedCountry == option ?
                                Color.gray.opacity(0.3) : Color.clear
                            )
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        }
                    }
                }
                
                Spacer().frame(height: 20)
            }
        }
        .presentationDetents([.height(500), .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}
