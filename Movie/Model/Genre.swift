//
//  Genre.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import Foundation

struct GenreResult: Decodable {
    let genres: [Genre]
    static var genreList : [Genre] = []
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
