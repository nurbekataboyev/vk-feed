//
//  NewsFeedViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import SnapKit

final class NewsFeedViewController: UIViewController {
    
    private var collectionView = NewsFeedCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layout()
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
    
}
