//
//  Trend.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import Foundation

struct MovieResult: Decodable {
    var page: Int
    var results: [Movie]
    let total_pages: Int
    let total_results: Int
}
    
struct Movie: Decodable {
    let backdrop_path: String?
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String?
    let title: String?
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
    var logo_path: String?
    
    var backDropURL: URL? {
        guard let path = backdrop_path else { return nil }
        return APIRequest.images(path: path).endPoint
    }
    
    var posterURL: URL? {
        guard let path = poster_path else { return nil }
        return APIRequest.images(path: path).endPoint
    }
    
    var logoURL: URL? {
        guard let path = logo_path else { return nil }
        return APIRequest.images(path: path).endPoint
    }
    
    var rateDescription: String {
        return String(format: "%.1f", vote_average)
    }
    
    var dateDescription: String {
        //date가 올바른 형식이면 M월 dd일로 변환해서 return
        //date가 올바른 형식이 아니면 원본 그대로 return
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: release_date)
        
        if let date {
            formatter.dateFormat = "M월\nd"
            let dateString = formatter.string(from: date)
            return dateString
        }else{
            return release_date
        }
    }
    
}

