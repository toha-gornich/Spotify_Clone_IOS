//
//  SideMenuView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI
struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .leading) {
                        if isShowing {
                            Color.black.opacity(0.5)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    isShowing.toggle()
                                }
                            
                            HStack {
                                VStack(spacing: 0) {
                            
                                    VStack(spacing: 12) {
                                        Spacer()
                                        
                                        HStack {
                                            // Avatar
                                            ZStack {
                                                Circle()
                                                    .fill(Color.focus)
                                                    .frame(width: 50, height: 50)
                                                
                                                Text("C")
                                                    .font(.system(size: 24, weight: .semibold))
                                                    .foregroundColor(.primaryText)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Call_the_ha")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.primaryText)
                                                
                                                Text("View profile")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.primaryText60)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 30)
                                        
                                        Spacer()
                                    }
                                    .frame(height: 120)
                                    .background(Color.bg)
                                    
                                    // Menu items
                                    VStack(spacing: 0) {
                                        Divider()
                                                .background(Color.elementBg)
                                        
                                        MenuItemView(icon: "plus", title: "Add account")
                                        
                                        MenuItemView(icon: "bolt.fill", title: "What's new")
                                        
                                        MenuItemView(icon: "clock", title: "Recents")
                                        
                                        MenuItemView(icon: "gearshape.fill", title: "Settings and privacy")
                                        
                                        Spacer()
                                    }
                                    .background(Color.bg)
                                }
                                .frame(width: .screenWidth * 0.85)
                                .background(Color.bg)
                                .transition(edgeTransition)
                                
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.3), value: isShowing)
        
    }
}




#Preview {
    MainView()
}
