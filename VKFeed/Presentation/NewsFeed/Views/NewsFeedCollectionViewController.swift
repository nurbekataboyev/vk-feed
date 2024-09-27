//
//  NewsFeedCollectionViewController.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit

final class NewsFeedCollectionViewController: UICollectionViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 12
    }
    
//    let posts: [NewsFeed] = [
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода. Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода. Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода. Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода. Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//        NewsFeed(id: UUID().uuidString, authorName: "Author", authorAvatarURL: "url", createdAt: Date(), text: "Единственным исключением был язык программирования Swift, который мы используем на нашем проекте."),
//    ]
    
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
        collectionView.showsVerticalScrollIndicator = true
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
            heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: GlobalConstants.Padding.padding, bottom: 0, trailing: GlobalConstants.Padding.padding)
        section.interGroupSpacing = Constants.spacing
        
        return section
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension NewsFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }
        
//        cell.configure(with: posts[indexPath.row])
        
        return cell
    }
    
}
