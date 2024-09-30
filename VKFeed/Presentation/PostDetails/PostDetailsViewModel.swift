//
//  PostDetailsViewModel.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation

protocol PostDetailsViewModel {
    func close()
}

final class PostDetailsViewModelImpl: PostDetailsViewModel {
    
    private let router: PostDetailsRouter
    
    init(router: PostDetailsRouter) {
        self.router = router
    }
    
    
    public func close() {
        router.close()
    }
    
}
