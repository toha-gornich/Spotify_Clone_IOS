//
//  TabButton.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct TabButton: View {
    @State var title: String = "Home"
    @State var icon: String = "home_tab"
    @State var iconUnfocus: String = "home_tab_f"
    var isSelect: Bool = false
    var didTap: (()->())?
    
    var body: some View {
        Button {
            didTap?()
        } label: {
            VStack {
                Image( isSelect ? icon : iconUnfocus)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                
                Text(title)
                    .font(.customFont(.regular, fontSize: 12))
                    .foregroundColor(isSelect ? .primaryText : .primaryText)
            }
        }
        
    }
}

#Preview {
    TabButton()
}
