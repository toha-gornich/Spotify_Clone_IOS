//
//  AccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 14.09.2025.
//

import SwiftUI

struct UserDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedTab: AccountTab
    @State private var showProfileFullScreen = false
    
    enum AccountTab: String, CaseIterable {
        case account = "Account"
        case profile = "Profile"
        case subscription = "Manage your subscription"
        case payment = "Payment"
        case settings = "Settings"
        case help = "Help"
    }
    
    
    init(selectedTab: AccountTab = .account) {
        self._selectedTab = State(initialValue: selectedTab)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.bg
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(spacing: 0) {
                            HStack {
                                HStack {
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }

                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    
                    Divider()
                        .background(Color.elementBg)
                        .padding(.top, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(AccountTab.allCases, id: \.self) { tab in
                                TabButtonAccount(
                                    title: tab.rawValue,
                                    isSelected: selectedTab == tab
                                ) {
                                    if tab == .profile {
                                        showProfileFullScreen = true
                                    } else {
                                        selectedTab = tab
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                    Divider()
                        .background(Color.elementBg)
                        .padding(.top, 10)
                    
                    
                    viewForSelectedTab()
                    
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showProfileFullScreen) {
            ProfileView()
        }
    }
        

    
    
    @ViewBuilder
    private func viewForSelectedTab() -> some View {
        switch selectedTab {
        case .account:
            AccountView()
        case .profile:
            Color.clear
        case .subscription:
            SubscriptionView()
        case .payment:
            PaymentView()
        case .settings:
            SettingsView()
        case .help:
            HelpView()
        }
    }
}


#Preview {
    UserDashboardView()
}
