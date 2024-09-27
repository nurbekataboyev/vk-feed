//
//  NewsFeedRouter.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit

protocol NewsFeedRouter {
    static func configure() -> UIViewController
}

final class NewsFeedRouterImpl: NewsFeedRouter {
    
    static func configure() -> UIViewController {
        let apiService = APIService()
        let keychainService = KeychainService()
        let accessTokenStorage = AccessTokenStorageImpl(keychainService: keychainService)
        let newsFeedRepository = NewsFeedRepositoryImpl(apiService: apiService, accessTokenStorage: accessTokenStorage)
        let fetchNewsFeedUseCase = FetchNewsFeedUseCaseImpl(repository: newsFeedRepository)
        let viewModel = NewsFeedViewModelImpl(fetchNewsFeedUseCase: fetchNewsFeedUseCase)
        let newsFeed = NewsFeedViewController(viewModel: viewModel)
        
        return newsFeed
    }
    
}
