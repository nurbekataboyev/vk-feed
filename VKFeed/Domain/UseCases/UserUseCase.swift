//
//  UserUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 05/10/24.
//

import Foundation
import Combine

protocol UserUseCase {
    func fetchUser() -> AnyPublisher<User, Error>
    func saveUser(_ user: User)
    func getUser() -> User?
    func clearUser()
}

final class UserUseCaseImpl: UserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchUser() -> AnyPublisher<User, Error> {
        return userRepository.fetchUser()
    }
    
    
    public func saveUser(_ user: User) {
        userRepository.saveUser(user)
    }
    
    
    public func getUser() -> User? {
        return userRepository.getUser()
    }
    
    
    public func clearUser() {
        userRepository.clearUser()
    }
    
}
