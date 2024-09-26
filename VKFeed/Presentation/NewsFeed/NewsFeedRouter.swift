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
        let newsFeed = NewsFeedViewController()
        return newsFeed
    }
    
}
