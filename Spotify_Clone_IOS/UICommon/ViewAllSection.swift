//
//  Title.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct ViewAllSection: View {
    
    @State var title: String =  "Title"
    @State var button: String = "View All"
    @State var buttonFlag: Bool = true
    var didTap: (()->())?
    
    var body: some View {
        HStack{
            Text(title)
                .font(.customFont(.bold, fontSize: 18))
                .foregroundColor(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            if buttonFlag {
                Button {
                    didTap?()
                } label: {
                    Text(button)
                        .font(.customFont(.regular, fontSize: 11))
                        .foregroundColor(.primaryText35)
                }
            }
        }.padding(.vertical, 16)
        
    }
}

#Preview {
    ViewAllSection()
}
