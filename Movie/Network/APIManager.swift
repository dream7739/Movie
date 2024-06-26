//
//  APIManager.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import Foundation
import Alamofire

final class APIManager {
    private init(){}
    
    static let shared = APIManager()
    
    func callRequest<T: Decodable>(request: APIRequest,
                                   completion: @escaping (Result<T, AFError>) -> Void){
        AF.request(request.endPoint,
                   method: request.method,
                   parameters: request.param,
                   encoding: URLEncoding.queryString,
                   headers: request.header)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
    }
}
