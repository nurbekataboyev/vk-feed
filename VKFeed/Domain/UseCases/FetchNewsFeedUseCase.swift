//
//  FetchNewsFeedUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol FetchNewsFeedUseCase {
    func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error>
}

final class FetchNewsFeedUseCaseImpl: FetchNewsFeedUseCase {
    
    private let repository: NewsFeedRepository
    
    init(repository: NewsFeedRepository) {
        self.repository = repository
    }
    
    public func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error> {
        return repository.fetchNewsFeed(startFrom: startFrom)
    }
    
}
