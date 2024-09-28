//
//  NewsFeedRepository.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol NewsFeedRepository {
    func fetchNewsFeed(startFrom: String?) -> AnyPublisher<NewsFeed, Error>
}
