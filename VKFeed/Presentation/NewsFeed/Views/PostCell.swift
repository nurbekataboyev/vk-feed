//
//  PostCell.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit
import SnapKit

final class PostCell: UICollectionViewCell {
    
    private struct Constans {
        static let avatarSize: CGFloat = 48
        static let tinyPadding: CGFloat = 4
    }
    
    private var authorAvatarImageView = VKImageView(contentMode: .scaleAspectFill)
    private var authorNameLabel = VKLabel(style: .headline, weight: .semibold)
    private var postDateLabel = VKLabel(style: .footnote, color: .secondaryLabel)
    private var postTextLabel = VKLabel(style: .subheadline)
    
    public func configure(with post: Post) {
        authorAvatarImageView.backgroundColor = .blue
        
        authorNameLabel.text = post.authorName
        
        postDateLabel.text = post.createdAt.ISO8601Format()
        
        postTextLabel.text = post.text
        
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupViews()
    }
    
    
    private func setupViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = GlobalConstants.CornerRadius.medium
        addShadow()
        
        addSubviews(authorAvatarImageView, authorNameLabel, postDateLabel, postTextLabel)
        
        authorAvatarImageView.layer.cornerRadius = Constans.avatarSize / 2
        authorAvatarImageView.clipsToBounds = true
        
        postTextLabel.numberOfLines = .max
    }
    
    
    private func layout() {
        authorAvatarImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(GlobalConstants.Padding.medium)
            $0.size.equalTo(Constans.avatarSize)
        }
        
        authorNameLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.top).offset(Constans.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.bottom.equalTo(authorAvatarImageView.snp.bottom).inset(Constans.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
        
        postTextLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.bottom).offset(GlobalConstants.Padding.small)
            $0.leading.trailing.equalToSuperview().inset(GlobalConstants.Padding.padding)
            $0.bottom.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
