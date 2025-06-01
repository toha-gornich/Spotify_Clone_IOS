//
//  ContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.05.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.customFont(.regular, fontSize: 11))
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
