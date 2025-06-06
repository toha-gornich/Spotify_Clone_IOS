//
//  MainView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainVM = MainViewModel.share

    var body: some View {
        ZStack{
            // Wrap each view in NavigationView for independent navigation
            if (mainVM.selectTab == 0){
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
            } else if (mainVM.selectTab == 1){
                NavigationView {
                    SearchView()
                        .navigationBarHidden(true)
                }
            } else if (mainVM.selectTab == 2){
                NavigationView {
                    LibraryView()
                        .navigationBarHidden(true)
                }
            }

            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    TabButton(title: "Home", icon: "home_tab_f", iconUnfocus: "home_tab", isSelect: mainVM.selectTab == 0) {
                        mainVM.selectTab = 0
                    }
                    
                    Spacer()
                    
                    TabButton(title: "Search",icon: "search_tab_f",
                              iconUnfocus: "search_tab",isSelect:
                                mainVM.selectTab == 1){
                        mainVM.selectTab = 1
                    }
                    
                    Spacer()
                    
                    TabButton(title: "Library",icon: "library_tab_f",
                              iconUnfocus: "library_tab",isSelect:
                                mainVM.selectTab == 2){
                        mainVM.selectTab = 2
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, .bottomInsets)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.bg.opacity(0.6),
                            Color.bg.opacity(0.8),
                            Color.bg.opacity(1),
                            Color.bg
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(radius: 2)
            }
            
            SideMenuView(isShowing: $mainVM.isShowMenu)
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}
#Preview {
    NavigationView{        
    MainView()
    }
    
}
