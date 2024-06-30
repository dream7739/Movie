//
//  APIRequest.swift
//  Movie
//
//  Created by 홍정민 on 6/26/24.
//

import Foundation
import Alamofire

enum APIRequest{
    case trend(page: Int)
    case images(path: String)
    case genre
    case search(query: String, page: Int)
    case cast(id: Int)
    case similar(id: Int)
    case recommend(id: Int)
    case poster(id: Int)
    case upcoming(page: Int)
    case popular(page: Int)
    case nowPlaying(page:Int)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var imageURL: String {
        return "https://image.tmdb.org/3/"
    }
    
    var endPoint: URL {
        switch self {
        case .trend:
            return URL(string: baseURL + "trending/movie/day")!
        case .images(let path):
            return URL(string: imageURL + "t/p/original\(path)")!
        case .genre:
            return URL(string: baseURL + "genre/movie/list")!
        case .search:
            return URL(string: baseURL + "search/movie")!
        case .cast(let id):
            return URL(string: baseURL + "movie/\(id)/credits")!
        case .similar(let id):
            return URL(string: baseURL + "movie/\(id)/similar")!
        case .recommend(let id):
            return URL(string: baseURL + "movie/\(id)/recommendations")!
        case .poster(id: let id):
            return URL(string: baseURL + "movie/\(id)/images")!
        case .upcoming:
            return URL(string: baseURL + "movie/upcoming")!
        case .popular:
            return URL(string: baseURL + "movie/popular")!
        case .nowPlaying:
            return URL(string: baseURL + "movie/now_playing")!

        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization" : APIKey.tmdb,
                "accept" : "application/json"]
    }
    
    var param: Parameters {
        switch self {
        case .trend(let page), .upcoming(let page), .popular(let page), .nowPlaying(let page):
            return ["language" : "ko-kr",
                    "page": page]
        case .images, .genre, .cast, .similar, .recommend:
            return ["language" : "ko-kr"]
        case .search(let query, let page):
            return ["query" : query,
                    "page": page]
        case .poster:
            return ["":""]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
