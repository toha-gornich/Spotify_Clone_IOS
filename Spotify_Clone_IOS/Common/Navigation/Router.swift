//
//  Router.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.02.2026.
//

import SwiftUI
import Combine


class Router: ObservableObject{
    
    @Published var path = NavigationPath()
    
    func navigateTo<T: Hashable>(_ route: T){
        path.append(route)
    }
    
    func goBack(){
        if !path.isEmpty{
            path.removeLast()
        }
    }
    
    func goRoot(){
        path = NavigationPath()
    }
    
}
