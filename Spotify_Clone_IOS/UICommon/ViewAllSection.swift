//
//  Title.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct ViewAllSection: View {
    @State var title: String = ""
    var body: some View {
        Text(title)
            .font(.customFont(.bold, fontSize: 18))
            .foregroundColor(.primaryText)
            .padding(.bottom,  .topInsets + 56)
            .padding(.horizontal, 20)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TitleView()
}
