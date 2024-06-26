//
//  Poster.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import Foundation

struct PosterResult: Decodable {
    let posters: [Poster]
}

struct Poster: Decodable {
    let file_path: String?
    
    var posterURL: URL? {
        guard let path = file_path else { return nil}
        return APIRequest.images(path: path).endPoint
    }
}