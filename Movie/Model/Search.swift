//
//  Search.swift
//  Movie
//
//  Created by 홍정민 on 6/11/24.
//

import Foundation

struct SearchResult: Decodable {
    let page: Int
    var results: [Search]
    let total_pages: Int
    let total_results: Int
}

struct Search: Decodable {
    let poster_path: String?
    let title: String?
    
    var posterURL: URL? {
        guard let path = poster_path,
              let url = URL(string: APIURL.imgURL + "/\(path)")else{
            return nil
        }
        
        return url
    }
}
