//
//  APIService.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

final class APIService {
    
    public func fetchData<Response: Decodable>(request: API.Request) -> AnyPublisher<Response, Error> {
        guard let request = request.createURLRequest() else {
            return Fail(error: VKError.Network.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw VKError.Network.invalidResponse
                }
                
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { _ in return VKError.Network.decodingFailed }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
