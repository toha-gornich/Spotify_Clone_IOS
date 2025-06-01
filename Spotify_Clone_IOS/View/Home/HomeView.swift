//
//  HomeView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI
import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var mainVM = MainViewModel.share
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    Button {
                        print("open Menu")
                        mainVM.isShowMenu = true
                    } label: {
                        Image("settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Text("Good morning")
                        .font(.customFont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    // Індикатор завантаження
                    if homeVM.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(0..<min(6, homeVM.tracks.count), id: \.self) { index in
                                if index == 0 {
                                    TrackCell(track: homeVM.tracks[index])
                                        .gridCellColumns(2)
                                } else {
                                    TrackCell(track: homeVM.tracks[index])
                                }
                            }
                        }
                        .task{
                            homeVM.getTracks()
                        }
                        
                        ViewAllSection(title: "Popular artists") {}
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.artists.indices, id: \.self) { index in
                                    
                                    let sObj = homeVM.artists[index]
                                    
                                    VStack {
                                        AsyncImageView(sObj.image, width: 140, height: 140)
                                            .padding(.bottom, 4)
                                            .clipShape(Circle())
                                        
                                        Text(sObj.displayName)
                            
                                            .font(.customFont(.bold, fontSize: 13))
                                            .foregroundColor(.primaryText)
                                            .lineLimit(2)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .task{
                            homeVM.getArtists()
                        }
                        
                        
                                                ViewAllSection(title: "Popular albums") {}
//                                                TrackTemplate(tracksArr: displayTracks)
                        //
                        //                        ViewAllSection(title: "Popular playlists") {}
                        //                        TrackTemplate(tracksArr: displayTracks)
                        //
                        //                        ViewAllSection(title: "Popular tracks") {}
                        //                        TrackTemplate(tracksArr: displayTracks)
                    }
                    .padding(.horizontal)
                }
            }
            if homeVM.isLoading{
                LoadingView()
            }
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .alert(item: $homeVM.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        
        
    }
}
#Preview {
    HomeView()
}
