//
//  VKError.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

struct VKError {
    
    enum General: LocalizedError {
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .unknownError:
                return "An unknown error occurred. Please try again"
            }
        }
    }
    
    
    enum Login: LocalizedError {
        case loginFailed
        
        var errorDescription: String? {
            switch self {
            case .loginFailed:
                return "Login attempt failed. Please try again"
            }
        }
    }
    
    
    enum Network: LocalizedError {
        case connectionFailed
        case invalidURL
        case invalidResponse
        case noData
        case decodingFailed
        
        var errorDescription: String? {
            switch self {
            case .connectionFailed:
                return "Failed to establish a connection. Please check your internet and try again"
            case .invalidURL:
                return "The URL is invalid"
            case .invalidResponse:
                return "Received an invalid response from the server"
            case .noData:
                return "No data received from the server"
            case .decodingFailed:
                return "Invalid data type. Decoding failed"
            }
        }
    }
    
    
    enum Token: LocalizedError {
        case invalidToken
        
        var errorDescription: String? {
            switch self {
            case .invalidToken:
                return "Invalid token. Please renew your token"
            }
        }
    }
    
}
