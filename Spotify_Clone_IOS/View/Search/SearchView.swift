//
//  SearchView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.07.2025.
//

import SwiftUI
struct SearchView: View {
    let searchText: String
    @State private var currentSearchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom App Bar
            HStack(spacing: 12) {
                // Search field with magnifying glass
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18))
                    
                    TextField("", text: $currentSearchText)
                        .foregroundColor(.white)
                        .font(.customFont(.regular, fontSize: 16))
                        .tint(.white) // Cursor color
                        .placeholder(when: currentSearchText.isEmpty) {
                            Text("What do you want to listen to?")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.customFont(.regular, fontSize: 16))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    
                    // Clear button container
                    HStack {
                        if !currentSearchText.isEmpty {
                            Button(action: {
                                currentSearchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(1))
                                    .font(.system(size: 18))
                            }
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.clear)
                                .font(.system(size: 18))
                        }
                    }
                    .frame(width: 18)
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(Color.primaryText.opacity(0.2))
                .cornerRadius(10)
                
                // Cancel button
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.customFont(.medium, fontSize: 14))
                }
                .fixedSize()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .padding(.top, .topInsets)
            .background(Color.lightBg)
            
            // Content area
            VStack {
                // Search results will go here
                Text("Search results for: \(searchText)")
                    .foregroundColor(.primaryText)
                    .font(.customFont(.regular, fontSize: 16))
                    .padding(.top, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bg)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            // Initialize search text from parameter
            currentSearchText = searchText
        }
    }
}

// Extension for placeholder functionality
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

#Preview {
    MainView()
}
