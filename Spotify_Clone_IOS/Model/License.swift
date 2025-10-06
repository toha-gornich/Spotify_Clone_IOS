//
//  License.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI


struct ResponseLicense: Codable{
    let licenses: [License]

}

struct License: Codable, Identifiable{
    let id: Int
    let artist: ArtistTracksMy
    let name: String
    let text: String
    
    
    static func empty() -> License {
            return License(
                id: 0,
                artist: ArtistTracksMy.empty(),
                name: "",
                text: ""
            )
        }
    
    
}
