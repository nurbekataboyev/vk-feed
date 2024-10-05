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
    func updateNewsFeed(with post: Post)
    
    func logout()
    
    func presentPostDetails(_ post: Post)
}

final class NewsFeedViewModelImpl: NewsFeedViewModel {
    
    // internal
    private let newsFeedUseCase: NewsFeedUseCase
    private let logoutUseCase: LogoutUseCase
    private let router: NewsFeedRouter
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var newsFeed: NewsFeed = NewsFeed(response: nil)
    @Published private var isLoading: Bool = false
    @Published private var errorMessage: String? = nil
    
    // external
    public var newsFeedPublisher: AnyPublisher<NewsFeed, Never> {
        return $newsFeed.eraseToAnyPublisher()
    }
    
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return $isLoading.eraseToAnyPublisher()
    }
    
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        return $errorMessage.eraseToAnyPublisher()
    }
    
    init(newsFeedUseCase: NewsFeedUseCase,
         logoutUseCase: LogoutUseCase,
         router: NewsFeedRouter) {
        self.newsFeedUseCase = newsFeedUseCase
        self.logoutUseCase = logoutUseCase
        self.router = router
    }
    
    public func viewDidLoad() {
        fetchNewsFeed()
    }
    
    
    public func fetchNewsFeed(shouldRefresh: Bool = false) {
        isLoading = true
        
        if shouldRefresh { newsFeed.response?.nextFrom = nil }
        
        newsFeedUseCase.fetchNewsFeed(startFrom: newsFeed.response?.nextFrom)
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
    
    
    public func updateNewsFeed(with post: Post) {
        guard let newsFeedItem = post.toNewsFeedItem(groups: newsFeed.response?.groups) else { return }
        
        if let index = newsFeed.response?.items.firstIndex(where: { $0.postID == newsFeedItem.postID }) {
            newsFeed.response?.items[index] = newsFeedItem
        }
    }
    
    
    public func logout() {
        isLoading = true
        
        logoutUseCase.logout()
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self.router.setLogin()
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
                
            } receiveValue: { _ in }
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
