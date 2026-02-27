//
//  MainViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    static var share:MainViewModel = MainViewModel()
    
    @Published var selectTab: Int = 0
    @Published var isShowMenu: Bool = false
}
