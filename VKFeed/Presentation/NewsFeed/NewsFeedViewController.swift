//
//  NewsFeedViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import Combine
import SnapKit

final class NewsFeedViewController: UIViewController {
    
    private let viewModel: NewsFeedViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView = NewsFeedCollectionViewController()
    private lazy var emptyStateView = VKEmptyStateView(viewController: self)
    private lazy var loadingView = VKLoadingView(viewController: self)
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupViews()
        layout()
        
        viewModel.viewDidLoad()
    }
    
    
    private func bindViewModel() {
        viewModel.newsFeedPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] newsFeed in
                guard let self else { return }
                updateNewsFeed(newsFeed)
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? loadingView.showLoadingView() : loadingView.dismissLoadingView()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] errorMessage in
                guard let self else { return }
                
                if let errorMessage {
                    presentAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func updateNewsFeed(_ newsFeed: NewsFeed) {
        guard let response = newsFeed.response else {
            updateEmptyStateView(isEmpty: true)
            return
        }
        
        let isEmpty = response.items.isEmpty
        updateEmptyStateView(isEmpty: isEmpty)
        
        if !isEmpty {
            let groups = response.groups
            let posts = response.items.map { $0.toPost(groups: groups) }
            
            collectionView.posts = posts
        }
    }
    
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "News Feed"
        
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutHandler))
        logoutButton.tintColor = .systemRed
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshNewsFeedHandler))
        let scrollToTopButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"), style: .plain, target: self, action: #selector(scrollToTopHandler))
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [refreshButton, scrollToTopButton]
        
        view.addSubview(collectionView.collectionView)
        
        collectionView.delegate = self
    }
    
    
    private func layout() {
        collectionView.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension NewsFeedViewController {
    
    @objc func logoutHandler() {
        let alert = UIAlertController(title: "Log Out?", message: "Dou you really want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            guard let self else { return }
            viewModel.logout()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        present(alert, animated: true)
    }
    
    
    @objc func refreshNewsFeedHandler() {
        refreshNews()
    }
    
    
    @objc func scrollToTopHandler() {
        collectionView.shouldScrollToTop = true
    }
    
    
    private func refreshNews() {
        collectionView.shouldScrollToTop = true
        viewModel.fetchNewsFeed(shouldRefresh: true)
    }
    
}


extension NewsFeedViewController {
    
    private func updateEmptyStateView(isEmpty: Bool) {
        let emptyStateImage = UIImage(systemName: "doc.text.magnifyingglass")
        isEmpty ? emptyStateView.showEmptyState(with: emptyStateImage) : emptyStateView.dismissEmptyState()
    }
    
}


extension NewsFeedViewController: NewsFeedCollectionDelegate {
    
    func didScrollToBottom() {
        viewModel.fetchNewsFeed(shouldRefresh: false)
    }
    
    
    func didTapPost(_ post: Post) {
        viewModel.presentPostDetails(post)
    }
    
}
