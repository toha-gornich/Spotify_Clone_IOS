//
//  AccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 14.09.2025.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedTab: AccountTab
    
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
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Go home")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("My account")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Manage your account settings.")
                                .font(.body)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(AccountTab.allCases, id: \.self) { tab in
                                TabButtonAccount(
                                    title: tab.rawValue,
                                    isSelected: selectedTab == tab
                                ) {
                                    selectedTab = tab
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    
                    contentForSelectedTab()
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func contentForSelectedTab() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text(titleForSelectedTab())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack {
                Text(descriptionForSelectedTab())
                    .font(.body)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        
        Spacer()
        
        
        VStack(spacing: 20) {
            Text("Still Under Development")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("We are still working on this page. Please check back later for updates.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                dismiss()
            }) {
                Text("Go Back")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 20)
        }
    }
    
    private func titleForSelectedTab() -> String {
        switch selectedTab {
        case .account:
            return "Account"
        case .profile:
            return "Profile"
        case .subscription:
            return "Subscriptions"
        case .payment:
            return "Payment Methods"
        case .settings:
            return "Settings"
        case .help:
            return "Help & Support"
        }
    }
    
    private func descriptionForSelectedTab() -> String {
        switch selectedTab {
        case .account:
            return "Manage your account information."
        case .profile:
            return "Edit your profile details."
        case .subscription:
            return "Configure your subscriptions."
        case .payment:
            return "Manage payment methods and billing."
        case .settings:
            return "Adjust your preferences."
        case .help:
            return "Get help and support."
        }
    }
}

struct TabButtonAccount: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            Capsule()
                                .stroke(Color.green, lineWidth: 2)
                        } else {
                            Color.clear
                        }
                    }
                )
        }
    }
}

#Preview {
    AccountView()
}
