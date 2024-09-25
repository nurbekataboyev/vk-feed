//
//  UseCase.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol UseCase {
    associatedtype Output
    func execute() -> AnyPublisher<Output, any Error>
}
