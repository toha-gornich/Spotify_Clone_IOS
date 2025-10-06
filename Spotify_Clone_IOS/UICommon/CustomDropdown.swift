//
//  CustomDropdown.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.10.2025.
//

import SwiftUI

struct CustomDropdown: View {
    let selectedItem: String?
    let placeholder: String
    let items: [String]
    let onSelect: (Int) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedItem ?? placeholder)
                        .foregroundColor(selectedItem == nil ? .gray : .white)
                        .font(.system(size: 16))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: isExpanded ? 8 : 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                        )
                )
            }
            
            // Dropdown List
            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                Button(action: {
                                    onSelect(index)
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isExpanded = false
                                    }
                                }) {
                                    HStack {
                                        Text(item)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Spacer()
                                        if selectedItem == item {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                    .padding()
                                    .background(
                                        selectedItem == item
                                        ? Color.gray.opacity(0.2)
                                        : Color.clear
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < items.count - 1 {
                                    Divider()
                                        .background(Color.gray.opacity(0.2))
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.bg.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .zIndex(isExpanded ? 1 : 0)
    }
}
