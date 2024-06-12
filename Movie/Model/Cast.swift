//
//  Cast.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import Foundation

struct CastResult: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
    let original_name: String
    let cast_id: Int?
    let character: String?
    let profile_path: String?
    
    
    var characterDescription: String {
        guard let character else { return ""}
        return character
    }
    
    var castDescription: String {
        guard let cast = cast_id else { return ""}
        return "\(cast)"
    }
    
    var description: String {
        return "\(characterDescription) / No.\(castDescription)"
    }
    
    var profileURL: URL? {
        guard let path = profile_path,
              let url = URL(string: APIURL.imgURL + "\(path)")else { return nil
        }
        return url
    }
    
}
