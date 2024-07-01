//
//  Video.swift
//  Movie
//
//  Created by 홍정민 on 7/1/24.
//

import Foundation

struct VideoResult: Decodable {
    let id: Int
    let results: [Video]
}

struct Video: Decodable {
    let name: String
    let key: String
}
