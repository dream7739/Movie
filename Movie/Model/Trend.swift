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
    let backdrop_path: String?
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String?
    let title: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
    
    var backDropURL: URL? {
        guard let path = backdrop_path,
              let url = URL(string: APIURL.imgURL + "/\(path)")else{
            return nil
        }
        
        return url
    }
    
    var posterURL: URL? {
        guard let path = poster_path,
              let url = URL(string: APIURL.imgURL + "/\(path)")else{
            return nil
        }
        
        return url
    }
    
    var rateDescription: String {
        return String(format: "%.1f", vote_average)
    }
    
    var dateDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: release_date)
        
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = formatter.string(from: date!)
        return dateString
    }
    
}

struct GenreResult: Decodable {
    let genres: [Genre]
    static var genreList : [Genre] = []
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
