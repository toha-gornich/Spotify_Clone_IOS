//
//  SearchVIew.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.07.2025.
//

import SwiftUI

struct GenreView: View {
    
    @StateObject private var genreVM = GenreViewModel()
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
                    
                    Text("Search")
                        .font(.customFont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    if genreVM.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(0..<genreVM.genres.count, id: \.self) { index in
                            if index == 0 {
                                SearchCardView(genre: genreVM.genres[index])
                                    .gridCellColumns(2)
                            } else {
                                SearchCardView(genre: genreVM.genres[index])
                            }
                        }
                    }.padding(.bottom, 100)
                    .task{
                        genreVM.getGenres()
                    }

                }
               
            }
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .alert(item: $genreVM.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        
        
    }
}
#Preview {
    NavigationView{
        
        MainView()
    }
}
