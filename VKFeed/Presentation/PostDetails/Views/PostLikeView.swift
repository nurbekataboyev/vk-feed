//
//  PostLikeView.swift
//  VKFeed
//
//  Created by Nurbek on 29/09/24.
//

import UIKit
import SnapKit

protocol PostLikeDelegate: AnyObject {
    func didToggleLike(for post: Post)
}

final class PostLikeView: UIView {
    
    private struct Constans {
        static let height: CGFloat = 48
        static let likeImageSize: CGFloat = 25
    }
    
    private var post: Post
    
    public weak var delegate: PostLikeDelegate?
    
    private var likeImageView = VKImageView(contentMode: .scaleAspectFill)
    private var likeCountLabel = VKLabel(style: .headline, weight: .medium)
    
    init(_ post: Post) {
        self.post = post
        super.init(frame: .zero)
        
        setupViews()
        updateLikeView()
        layout()
    }
    
    
    public func revertLike() {
        updatePostLikes()
        updateLikeView()
    }
    
    
    private func setupViews() {
        layer.cornerRadius = Constans.height / 2
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        let toggleLikeGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLikeHandler))
        addGestureRecognizer(toggleLikeGesture)
        
        addSubviews(likeImageView, likeCountLabel)
    }
    
    
    private func updateLikeView() {
        backgroundColor = post.likes.userLikes ? .vkLikeSecondary : .secondarySystemBackground
        
        likeImageView.image = UIImage(systemName: post.likes.userLikes ? "heart.fill" : "heart")
        likeImageView.tintColor = post.likes.userLikes ? .vkLikePrimary : .secondaryLabel
        
        likeCountLabel.text = "\(post.likes.count)"
        likeCountLabel.textColor = post.likes.userLikes ? .vkLikePrimary : .secondaryLabel
    }
    
    
    private func layout() {
        snp.makeConstraints {
            $0.height.equalTo(Constans.height)
        }
        
        likeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(GlobalConstants.Padding.medium)
            $0.size.equalTo(Constans.likeImageSize)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(likeImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PostLikeView {
    
    @objc func toggleLikeHandler() {
        delegate?.didToggleLike(for: post)
        
        updatePostLikes()
        updateLikeView()
        
        makeVibration(.medium)
    }
    
    
    private func updatePostLikes() {
        post.likes.userLikes.toggle()
        post.likes.count += post.likes.userLikes ? 1 : -1
    }
    
}
