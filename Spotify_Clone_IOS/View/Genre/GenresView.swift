//
//  SearchVIew.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.07.2025.
//

import SwiftUI

struct GenresView: View {
    @State private var searchText = ""
    @State private var searchQuery = ""
    @ObservedObject var genreVM: GenresViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var playerManager: AudioPlayerManager

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(spacing: 15) {
                    Button {
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
                        ProgressView().scaleEffect(0.8)
                    }
                }
                .padding(.horizontal, 20)

                // Search Field
                HStack {
                    Button(action: { performSearch() }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                    }

                    TextField("", text: $searchText, prompt: Text("What do you want to listen to?")
                        .foregroundColor(.gray.opacity(0.6))
                    )
                    .foregroundColor(.black)
                    .font(.customFont(.regular, fontSize: 16))
                    .onSubmit { performSearch() }

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 18))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)

                // Grid
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(0..<genreVM.genres.count, id: \.self) { index in
                            let sObj = genreVM.genres[index]
                            Button() {
                                router.navigateTo(AppRoute.genreDetails(slugGenre: sObj.slug))
                            } label: {
                                if index == 0 {
                                    SearchCardView(genre: sObj).gridCellColumns(2)
                                } else {
                                    SearchCardView(genre: sObj)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .task { genreVM.getGenres() }
            }
        }
        .hideKeyboard()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .alert(item: $genreVM.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }

    private func performSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        searchQuery = trimmed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            router.navigateTo(AppRoute.search(searchText: searchQuery))
        }
    }
}
