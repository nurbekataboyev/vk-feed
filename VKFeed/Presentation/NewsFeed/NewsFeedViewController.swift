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
            .sink { newsFeed in
                
                guard let _ = newsFeed.response else { return }
                
                for item in newsFeed.response!.items {
                    print("---")
                    print(item)
                    print("---")
                }
                
                for item in newsFeed.response!.groups {
                    print("---")
                    print(item)
                    print("---")
                }
                
                print("---")
                print(newsFeed.response!.nextFrom)
                print("---")
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
    
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.title = "News Feed"
        
        view.addSubview(collectionView.collectionView)
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
