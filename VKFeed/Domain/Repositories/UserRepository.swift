//
//  UserRepository.swift
//  VKFeed
//
//  Created by Nurbek on 05/10/24.
//

import Foundation
import Combine

protocol UserRepository {
    func fetchUser() -> AnyPublisher<User, Error>
    func saveUser(_ user: User)
    func getUser() -> User?
    func clearUser()
}
