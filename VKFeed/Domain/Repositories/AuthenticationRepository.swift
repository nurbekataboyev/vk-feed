//
//  LoginRepository.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

protocol AuthenticationRepository {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
}
