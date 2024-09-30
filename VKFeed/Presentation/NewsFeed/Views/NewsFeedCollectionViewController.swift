//
//  NewsFeedCollectionViewController.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

protocol NewsFeedCollectionDelegate: AnyObject {
    func didScrollToBottom()
    func didTapPost(_ post: Post)
}

final class NewsFeedCollectionViewController: UICollectionViewController {
    
    private struct Constants {
        static let estimatedCellHeight: CGFloat = 50
        static let spacing: CGFloat = 12
    }
    
    public weak var delegate: NewsFeedCollectionDelegate?
    public var posts: [Post] = [] { didSet { collectionView.reloadData() } }
    public var shouldScrollToTop: Bool = false { didSet { scrollToTop() } }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    
    private func setupViews() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: Constants.spacing, left: 0, bottom: 100, right: 0)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
    }
    
    
    private func setupLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else { return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0), heightDimension: .fractionalHeight(0)))) }
            
            return setupPostLayout()
        }
        
        return layout
    }
    
    
    private func setupPostLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.estimatedCellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.estimatedCellHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: GlobalConstants.Padding.padding, bottom: 0, trailing: GlobalConstants.Padding.padding)
        section.interGroupSpacing = Constants.spacing
        
        return section
    }
    
    
    private func scrollToTop() {
        if posts.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension NewsFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.setup(with: post)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = posts.count - 1
        let lastIndex = IndexPath(row: lastRow, section: 0)
        
        if lastIndex == indexPath {
            delegate?.didScrollToBottom()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        delegate?.didTapPost(selectedPost)
    }
    
}
