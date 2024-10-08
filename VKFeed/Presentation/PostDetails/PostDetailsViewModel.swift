//
//  PostDetailsViewModel.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine

protocol PostDetailsViewModel {
    var postPublisher: AnyPublisher<Post, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    func toggleLike(for post: Post)
    
    func close()
}

final class PostDetailsViewModelImpl: PostDetailsViewModel {
    
    // internal
    private let postLikeUseCase: PostLikeUseCase
    private let router: PostDetailsRouter
    
    private var likeToggleSubject = PassthroughSubject<Post, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var post: Post
    @Published private var errorMessage: String? = nil
    
    // external
    public var postPublisher: AnyPublisher<Post, Never> {
        return $post.eraseToAnyPublisher()
    }
    
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        return $errorMessage.eraseToAnyPublisher()
    }
    
    init(post: Post,
         postLikeUseCase: PostLikeUseCase,
         router: PostDetailsRouter) {
        self.post = post
        self.postLikeUseCase = postLikeUseCase
        self.router = router
        
        setupLikeToggleDebounce()
    }
    
    
    public func toggleLike(for post: Post) {
        likeToggleSubject.send(post)
    }
    
    
    public func close() {
        router.close()
    }
    
}


extension PostDetailsViewModelImpl {
    
    private func setupLikeToggleDebounce() {
        likeToggleSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] post in
                guard let self else { return }
                performLikeToggle(for: post)
            }
            .store(in: &cancellables)
    }
    
    
    private func performLikeToggle(for post: Post) {
        postLikeUseCase.toggleLike(for: post)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    self.post = post // old post
                    errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] updatedPost in
                guard let self else { return }
                self.post = updatedPost
            }
            .store(in: &cancellables)
    }
    
}
