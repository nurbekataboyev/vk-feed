//
//  NewsFeedViewModel.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol NewsFeedViewModel {
    var newsFeedPublisher: AnyPublisher<NewsFeed, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    func viewDidLoad()
    func fetchNewsFeed()
}

final class NewsFeedViewModelImpl: NewsFeedViewModel {
    
    @Published private var newsFeed: NewsFeed = NewsFeed(response: nil)
    @Published private var errorMessage: String? = nil
    
    public var newsFeedPublisher: AnyPublisher<NewsFeed, Never> {
        return $newsFeed.eraseToAnyPublisher()
    }
    
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        return $errorMessage.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchNewsFeedUseCase: FetchNewsFeedUseCase
    
    init(fetchNewsFeedUseCase: FetchNewsFeedUseCase) {
        self.fetchNewsFeedUseCase = fetchNewsFeedUseCase
    }
    
    public func viewDidLoad() {
        fetchNewsFeed()
    }
    
    
    public func fetchNewsFeed() {
        fetchNewsFeedUseCase.fetchNewsFeed()
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] newsFeed in
                guard let self else { return }
                self.newsFeed = newsFeed
            }
            .store(in: &cancellables)
    }
    
}
