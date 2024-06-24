//
//  APIManager.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    let header: HTTPHeaders = [
        "Authorization" : APIKey.trendKey,
        "accept" : "application/json"
    ]
    
    private init(){}
    
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
      
    
    func callTrend(page: Int, completion: @escaping (TrendResult) -> Void){
        
        let param: Parameters = ["language" : "ko-kr",
                                 "page": page]
        
        AF.request(APIURL.trendURL,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: TrendResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
