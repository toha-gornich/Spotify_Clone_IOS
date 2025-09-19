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
    let countries: [CountryData]
    
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
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(countries, id: \.code) { country in
                            if country.code == "SEPARATOR" {
                                Text(country.name)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 8)
                                    .disabled(true)
                            } else {
                                Button(action: {
                                    selectedCountry = country.name
                                    showCountryPicker = false
                                }) {
                                    HStack {
                                        Text(country.name)
                                            .font(.system(size: 18))
                                            .foregroundColor(selectedCountry == country.name ? .white : .gray)
                                            .padding(.vertical, 12)
                                        
                                        Spacer()
                                        
                                        if selectedCountry == country.name {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .background(
                                    selectedCountry == country.name ?
                                    Color.gray.opacity(0.3) : Color.clear
                                )
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .presentationDetents([.height(600)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}
