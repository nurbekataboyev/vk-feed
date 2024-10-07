//
//  UserRepositoryImpl.swift
//  VKFeed
//
//  Created by Nurbek on 05/10/24.
//

import Foundation
import Combine

final class UserRepositoryImpl: UserRepository {
    
    private let apiService: APIService
    private let userStorage: UserStorage
    private let tokenManager: TokenManager
    
    init(apiService: APIService,
         userStorage: UserStorage,
         tokenManager: TokenManager) {
        self.apiService = apiService
        self.userStorage = userStorage
        self.tokenManager = tokenManager
    }
    
    public func fetchUser() -> AnyPublisher<User, Error> {
        return tokenManager.getValidAccessToken()
            .flatMap { [weak self] accessToken -> AnyPublisher<User, Error> in
                guard let self else { return Fail(error: VKError.Token.invalidToken).eraseToAnyPublisher() }
                
                let request = API.Request(
                    scheme: VKAPI.scheme,
                    host: VKAPI.host,
                    path: VKAPI.Paths.usersGet.path,
                    method: .POST,
                    parameters: VKAPI.Paths.usersGet.parameters(withAccessToken: accessToken))
                
                return apiService.fetchData(request: request)
            }
            .eraseToAnyPublisher()
    }
    
    
    public func saveUser(_ user: User) {
        userStorage.saveUser(user)
    }
    
    
    public func getUser() -> User? {
        return userStorage.getUser()
    }
    
    
    public func clearUser() {
        userStorage.clearUser()
    }
    
}
