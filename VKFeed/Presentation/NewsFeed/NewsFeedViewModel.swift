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
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    func viewDidLoad()
    func fetchNewsFeed(shouldRefresh: Bool)
    func presentPostDetails(_ post: Post)
}

final class NewsFeedViewModelImpl: NewsFeedViewModel {
    
    @Published private var newsFeed: NewsFeed = NewsFeed(response: nil)
    @Published private var isLoading: Bool = false
    @Published private var errorMessage: String? = nil
    
    public var newsFeedPublisher: AnyPublisher<NewsFeed, Never> {
        return $newsFeed.eraseToAnyPublisher()
    }
    
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return $isLoading.eraseToAnyPublisher()
    }
    
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        return $errorMessage.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchNewsFeedUseCase: FetchNewsFeedUseCase
    private let router: NewsFeedRouter
    
    init(fetchNewsFeedUseCase: FetchNewsFeedUseCase,
         router: NewsFeedRouter) {
        self.fetchNewsFeedUseCase = fetchNewsFeedUseCase
        self.router = router
    }
    
    public func viewDidLoad() {
        fetchNewsFeed()
    }
    
    
    public func fetchNewsFeed(shouldRefresh: Bool = false) {
        isLoading = true
        
        if shouldRefresh { newsFeed.response?.nextFrom = nil }
        
        fetchNewsFeedUseCase.fetchNewsFeed(startFrom: newsFeed.response?.nextFrom)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] newsFeed in
                guard let self else { return }
                updateNewsFeed(newsFeed, shouldRefresh: shouldRefresh)
            }
            .store(in: &cancellables)
    }
    
    
    public func presentPostDetails(_ post: Post) {
        router.presentPostDetails(post)
    }
    
}


extension NewsFeedViewModelImpl {
    
    private func updateNewsFeed(_ newsFeed: NewsFeed, shouldRefresh: Bool) {
        guard !shouldRefresh else {
            self.newsFeed = newsFeed
            return
        }
        
        if self.newsFeed.response == nil {
            self.newsFeed = newsFeed
        } else {
            let fetchedItems = newsFeed.response?.items ?? []
            let fetchedGroups = newsFeed.response?.groups ?? []
            let fetchedNextFrom = newsFeed.response?.nextFrom
            let existingGroups = self.newsFeed.response?.groups ?? []
            
            let newGroups = fetchedGroups.filter { group in
                !existingGroups.contains(where: { $0.id == group.id })
            }
            
            var updatedNewsFeed = self.newsFeed
            updatedNewsFeed.response?.items.append(contentsOf: fetchedItems)
            updatedNewsFeed.response?.groups.append(contentsOf: newGroups)
            updatedNewsFeed.response?.nextFrom = fetchedNextFrom
            
            self.newsFeed = updatedNewsFeed
        }
    }
    
}
