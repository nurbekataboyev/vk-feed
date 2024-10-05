//
//  NewsFeedUseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol NewsFeedUseCase {
    func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error>
}

final class NewsFeedUseCaseImpl: NewsFeedUseCase {
    
    private let newsFeedRepository: NewsFeedRepository
    
    init(newsFeedRepository: NewsFeedRepository) {
        self.newsFeedRepository = newsFeedRepository
    }
    
    public func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error> {
        return newsFeedRepository.fetchNewsFeed(startFrom: startFrom)
    }
    
}
