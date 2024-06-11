//
//  Search.swift
//  Movie
//
//  Created by 홍정민 on 6/11/24.
//

import Foundation

struct SearchResult: Decodable {
    let page: Int
    let result: [Search]
}

struct Search: Decodable {
    let poster_path: String
    let release_date: String
    vote_average
}
