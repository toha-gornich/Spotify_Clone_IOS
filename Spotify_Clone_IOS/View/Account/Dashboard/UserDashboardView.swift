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
    @StateObject private var dashboardVM = UserDashboardViewModel()
    @State private var showProfileFullScreen = false
    
    enum AccountTab: String, CaseIterable {
        case account = "Account"
        case artistProfile = "Artist profile"
        case profile = "Profile"
        case tracks = "Artist tracks"
        case albums = "Artist albums"
        case license = "Artist license"
        case subscription = "Manage your subscription"
        case payment = "Payment"
        case settings = "Settings"
        case analytics = "Analytics"
        case help = "Help"
    }
    
    // Computed property to get available tabs based on user type
    private var availableTabs: [AccountTab] {
        if dashboardVM.isActor {
            // User tabs
            return [.account, .profile, .subscription, .payment, .settings, .help]
        } else {
            // Actor tabs
            return [.account, .artistProfile, .tracks, .albums, .license, .subscription, .payment, .settings, .analytics, .help]
        }
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
                            ForEach(availableTabs, id: \.self) { tab in
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
            .task {
                Task {
                    await dashboardVM.getUserMe()
                }
            }
            .onChange(of: dashboardVM.isActor) { _ in
                if !availableTabs.contains(selectedTab) {
                    selectedTab = .account
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
        case .artistProfile:
            ArtistProfileView()
        case .profile:
            Color.clear
        case .tracks:
            ArtistTracksView()
        case .albums:
            ArtistAlbumsView()
        case .license:
            ArtistLicenseView()
        case .subscription:
            SubscriptionView()
        case .payment:
            PaymentView()
        case .settings:
            SettingsView()
        case .analytics:
            AnalyticsView()
        case .help:
            HelpView()
        }
    }
}


#Preview {
    UserDashboardView()
}
