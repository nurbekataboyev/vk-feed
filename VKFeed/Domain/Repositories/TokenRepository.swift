//
//  TokenRepository.swift
//  VKFeed
//
//  Created by Nurbek on 06/10/24.
//

import Foundation
import Combine

protocol TokenRepository {
    func refreshTokens() -> AnyPublisher<TokenResponse, Error>
    
    func isAccessTokenValid() -> Bool
    func getAccessToken() -> String?
    func saveTokens(accessToken: String, refreshToken: String, deviceID: String, expiresIn: Int)
    func updateTokens(accessToken: String, refreshToken: String, expiresIn: Int)
    func clearTokens()
}
