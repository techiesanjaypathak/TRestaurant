//
//  WebService.swift
//  TRestaurant
//
//  Created by SanjayPathak on 24/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import Foundation

enum HttpMethod : String {
    case get
    case post
}

struct Resource<T:Codable> {
    let url:URL
    var httpMethod:HttpMethod = .get
    var body:Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

enum NetworkError:Error {
    case domainError
    case decodingError
}

class WebService {
    func load<T>(resource:Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                completion(.success(result))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
