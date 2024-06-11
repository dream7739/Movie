//
//  Trend.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import Foundation

struct TrendResult: Decodable {
    let results: [Trend]
}
    
struct Trend: Decodable {
    let backdrop_path: String
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let title: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}

struct GenreResult: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
