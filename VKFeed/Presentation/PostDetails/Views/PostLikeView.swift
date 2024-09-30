//
//  PostLikeView.swift
//  VKFeed
//
//  Created by Nurbek on 29/09/24.
//

import UIKit
import SnapKit

final class PostLikeView: UIView {
    
    private struct Constans {
        static let height: CGFloat = 48
        static let likeImageHeight: CGFloat = 25
    }
    
    private var postLikes: PostLikes
    
    private var likeImageView = VKImageView(contentMode: .scaleAspectFill)
    private var likeCountLabel = VKLabel(style: .headline, weight: .medium)
    
    init(_ postLikes: PostLikes) {
        self.postLikes = postLikes
        super.init(frame: .zero)
        
        setupViews()
        updateLikeView()
        layout()
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
        backgroundColor = postLikes.userLikes ? .vkLikeSecondary : .secondarySystemBackground
        
        likeImageView.image = UIImage(systemName: postLikes.userLikes ? "heart.fill" : "heart")
        likeImageView.tintColor = postLikes.userLikes ? .vkLikePrimary : .secondaryLabel
        
        likeCountLabel.text = "\(postLikes.count)"
        likeCountLabel.textColor = postLikes.userLikes ? .vkLikePrimary : .secondaryLabel
    }
    
    
    private func layout() {
        snp.makeConstraints {
            $0.height.equalTo(Constans.height)
        }
        
        likeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(GlobalConstants.Padding.medium)
            $0.size.equalTo(Constans.likeImageHeight)
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
        updatePostLikes()
        updateLikeView()
        
        makeVibration(.medium)
    }
    
    
    private func updatePostLikes() {
        postLikes.userLikes.toggle()
        postLikes.count += postLikes.userLikes ? 1 : -1
    }
    
}
