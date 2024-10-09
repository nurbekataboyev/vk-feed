//
//  PostCell.swift
//  VKFeed
//
//  Created by Nurbek on 26/09/24.
//

import UIKit
import SnapKit

final class PostCell: UICollectionViewCell {
    
    private struct Constants {
        static let avatarSize: CGFloat = 48
        static let tinyPadding: CGFloat = 4
        
        static func calculatePostImageHeight(_ post: Post?, in view: UIView) -> CGFloat {
            if let originalHeight = post?.photo?.height,
               let originalWidth = post?.photo?.width {
                let postImageWidth: Double = view.bounds.width - (2 * GlobalConstants.Padding.padding)
                let aspectRatio = Double(originalHeight) / Double(originalWidth)
                let postImageHeight = postImageWidth * aspectRatio
                
                return postImageHeight
            }
            return 0
        }
    }
    
    private var post: Post?
    
    private var authorAvatarImageView = VKImageView(contentMode: .scaleAspectFill)
    private var authorNameLabel = VKLabel(style: .headline, weight: .semibold)
    private var postDateLabel = VKLabel(style: .footnote, color: .secondaryLabel)
    private var postTextLabel = VKLabel(style: .subheadline)
    private var postImageView = VKImageView(contentMode: .scaleAspectFill)
    
    public func setup(with post: Post) {
        self.post = post
        
        authorAvatarImageView.setImage(from: post.author?.photoURL, placeholder: .profileImagePlaceholder)
        
        authorNameLabel.text = post.author?.name
        
        postDateLabel.text = post.createdAt.toPostDateFormat()
        
        postTextLabel.text = post.text
        
        if let photoURL = post.photo?.photoURL {
            postImageView.setImage(from: photoURL, placeholder: .postPlaceholder)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
        
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        post = nil
        
        authorAvatarImageView.image = nil
        authorNameLabel.text = nil
        postDateLabel.text = nil
        postTextLabel.text = nil
        postImageView.image = nil
        
        authorAvatarImageView.snp.removeConstraints()
        authorNameLabel.snp.removeConstraints()
        postDateLabel.snp.removeConstraints()
        postTextLabel.snp.removeConstraints()
        postImageView.snp.removeConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupViews()
    }
    
    
    private func setupViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = GlobalConstants.CornerRadius.medium
        addShadow()
        
        addSubviews(authorAvatarImageView, authorNameLabel, postDateLabel, postTextLabel, postImageView)
        
        authorAvatarImageView.layer.cornerRadius = Constants.avatarSize / 2
        authorAvatarImageView.clipsToBounds = true
        
        postTextLabel.numberOfLines = .max
        
        postImageView.layer.cornerRadius = GlobalConstants.CornerRadius.small
        postImageView.clipsToBounds = true
    }
    
    
    private func layout() {
        let postHasImage = postImageView.image != nil
        
        authorAvatarImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(GlobalConstants.Padding.medium)
            $0.size.equalTo(Constants.avatarSize)
        }
        
        authorNameLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.top).offset(Constants.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.bottom.equalTo(authorAvatarImageView.snp.bottom).inset(Constants.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalToSuperview().inset(GlobalConstants.Padding.medium)
        }
        
        postTextLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.bottom).offset(GlobalConstants.Padding.small)
            $0.leading.trailing.equalToSuperview().inset(GlobalConstants.Padding.padding)
        }
        
        if postHasImage {
            postImageView.snp.makeConstraints {
                $0.top.equalTo(postTextLabel.snp.bottom).offset(GlobalConstants.Padding.small)
                $0.leading.trailing.equalToSuperview().inset(GlobalConstants.Padding.padding)
                $0.bottom.equalToSuperview().inset(GlobalConstants.Padding.medium)
                $0.height.equalTo(Constants.calculatePostImageHeight(post, in: self))
            }
        } else {
            postTextLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(GlobalConstants.Padding.medium)
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
