//
//  APIManager.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import Foundation
import Alamofire

class APIManager {
    private init(){}
    
    static let shared = APIManager()
    
    let header: HTTPHeaders = [
        "Authorization" : APIKey.trendKey,
        "accept" : "application/json"
    ]
    

    func callGenreList(completion: @escaping () -> Void ){
          let param: Parameters = ["language" : "ko-kr"]
          
          AF.request(APIURL.genreURL,
                     method: .get,
                     parameters: param,
                     encoding: URLEncoding.queryString,
                     headers: header)
          .responseDecodable(of: GenreResult.self) { response in
              switch response.result {
              case .success(let value):
                  GenreResult.genreList = value.genres
                  completion()
              case .failure(let error):
                  print(error)
              }
          }
      }
      
    
    func callTrend(page: Int, completion: @escaping (MovieResult) -> Void){
        
        let param: Parameters = ["language" : "ko-kr",
                                 "page": page]
        
        AF.request(APIURL.trendURL,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: MovieResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callCast(id: Int, completion: @escaping (CastResult) -> Void ){
        
        let url = APIURL.castURL + "/\(id)/credits?language=ko-kr"
        
        AF.request(url,
                   method: .get,
                   headers: header)
        .responseDecodable(of: CastResult.self) { response in
                switch response.result {
                case .success(let value):
                    completion(value)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func callSimilar(id: Int, page: Int, completion: @escaping (MovieResult) -> Void){
        let url = APIURL.similarURL + "/\(id)/similar"
        
        let param: Parameters = ["language" : "ko-kr",
                                 "page": page]
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: MovieResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callRecommend(id: Int, page: Int, completion: @escaping (MovieResult) -> Void){
        let url = APIURL.similarURL + "/\(id)/recommendations"
        
        let param: Parameters = ["language" : "ko-kr",
                                 "page": page]
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: MovieResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
