//
//  SideMenuView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI
struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var showGreeting = false
    @State private var showAccount = false
    @State private var selectedAccountTab: UserDashboardView.AccountTab = .account
    
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
                            
                            MenuItemView(icon: "person.crop.circle.badge.plus", title: "Account",
                                         action: {
                                selectedAccountTab = .account
                                showAccount = true
                            })
                            .fullScreenCover(isPresented: $showAccount) {
                                UserDashboardView(selectedTab: selectedAccountTab)
                            }
                            
                            MenuItemView(icon: "person.circle.fill", title: "Profile",
                                         action: {
                                selectedAccountTab = .profile
                                showAccount = true
                            })
                            
                            MenuItemView(icon: "crown.fill", title: "Upgrade to Premium",
                                         action: {
                                selectedAccountTab = .subscription
                                showAccount = true
                            })
                            
                            MenuItemView(icon: "gearshape.fill", title: "Settings",
                                         action: {
                                selectedAccountTab = .settings
                                showAccount = true
                            })
                            
                            Divider()
                                .background(Color.elementBg)
                            
                            MenuItemView(icon: "rectangle.portrait.and.arrow.right", title: "Log out") {
                                logOut()
                                showGreeting = true
                            }
                            .fullScreenCover(isPresented: $showGreeting) {
                                GreetingView()
                                    .onDisappear {
                                        showGreeting = false
                                    }
                            }
                            
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
    
        func logOut() {
            UserDefaults.standard.removeObject(forKey: "auth_token")
            
            
            URLCache.shared.removeAllCachedResponses()
            
        }
    
}




#Preview {
    NavigationView{
        MainView()
    }
}
