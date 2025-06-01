//
//  SideMenuView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing:Bool
    
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            if(isShowing) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                HStack {
                    ScrollView{
                        VStack {
                        
                        Spacer()
                        
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: .screenWidth * 0.17 , height: .screenWidth * 0.30)
                        
                        HStack{
                            Spacer()
                            VStack{
                                Text("328\nSongs")
                                    .multilineTextAlignment(.center)
                                    .font(.customFont(.regular, fontSize: 12))
                                    .foregroundColor( Color(hex: "C1C0C0") )
                            }
                            Spacer()
                            VStack{
                                Text("52\nAlbums")
                                    .multilineTextAlignment(.center)
                                    .font(.customFont(.regular, fontSize: 12))
                                    .foregroundColor( Color(hex: "C1C0C0") )
                            }
                            Spacer()
                            VStack{
                                Text("87\nArtists")
                                    .multilineTextAlignment(.center)
                                    .font(.customFont(.regular, fontSize: 12))
                                    .foregroundColor( Color(hex: "C1C0C0") )
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                    }
                    .frame(height: 240)
                    .background(Color.primaryText.opacity(0.03))
                        
                        LazyVStack{
                            
                        }
                        .padding(15)
                }
                    
                .frame(width: .screenWidth * 0.7 )
                .background(Color.bg)
                .transition(edgeTransition)
                .background(Color.clear)
                    Spacer()
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom )
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    @State static var isShow: Bool = true
    static var previews: some View {
        SideMenuView(isShowing: $isShow)
    }
}
