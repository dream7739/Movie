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
}
