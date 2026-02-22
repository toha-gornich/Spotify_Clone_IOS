//
//  BackButton.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.02.2026.
//

import SwiftUI

struct BackButton:View{
    
    @EnvironmentObject var router: Router

    var body: some View{
        Button(action: {
            router.goBack()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.bg)
                )
                .background(.ultraThinMaterial, in: Circle())
                .clipShape(Circle())
        }
//        .padding(.leading, 16)
//        .padding(.top, 16)
    }
    
}

