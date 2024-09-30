//
//  PostDetailsViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import SnapKit

final class PostDetailsViewController: UIViewController {
    
    private struct Constans {
        static let avatarSize: CGFloat = 48
        static let tinyPadding: CGFloat = 4
    }
    
    private var post: Post
    private let viewModel: PostDetailsViewModel
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    private var authorAvatarImageView = VKImageView(contentMode: .scaleAspectFill)
    private var authorNameLabel = VKLabel(style: .headline, weight: .semibold)
    private var postDateLabel = VKLabel(style: .footnote, color: .secondaryLabel)
    private var postTextLabel = VKLabel(style: .subheadline)
    private var postImageView = VKImageView(contentMode: .scaleAspectFill)
    private lazy var postLikeView = PostLikeView(post.likes)
    
    init(_ post: Post,
         viewModel: PostDetailsViewModel) {
        self.post = post
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupPost()
        layout()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.title = "Post Details"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonHandler))
        navigationItem.leftBarButtonItem = closeButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(authorAvatarImageView, authorNameLabel, postDateLabel, postTextLabel, postImageView, postLikeView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        
        containerView.backgroundColor = .systemBackground
        containerView.addShadow()
        
        authorAvatarImageView.layer.cornerRadius = Constans.avatarSize / 2
        authorAvatarImageView.clipsToBounds = true
        
        postTextLabel.numberOfLines = .max
        
        postImageView.layer.cornerRadius = GlobalConstants.CornerRadius.small
        postImageView.clipsToBounds = true
    }
    
    
    private func setupPost() {
        authorAvatarImageView.setImage(from: post.author?.photoURL, placeholder: .profileImagePlaceholder)
        
        authorNameLabel.text = post.author?.name
        
        postDateLabel.text = post.createdAt.toPostDateFormat()
        
        postTextLabel.text = post.text
        
        postImageView.setImage(from: post.photoURL, placeholder: .postPlaceholder)
    }
    
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.snp.edges)
            $0.width.equalTo(view.bounds.width)
        }
        
        authorAvatarImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(GlobalConstants.Padding.medium)
            $0.leading.equalTo(containerView.snp.leading).offset(GlobalConstants.Padding.medium)
            $0.size.equalTo(Constans.avatarSize)
        }
        
        authorNameLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.top).offset(Constans.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalTo(containerView.snp.trailing).inset(GlobalConstants.Padding.medium)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.bottom.equalTo(authorAvatarImageView.snp.bottom).inset(Constans.tinyPadding)
            $0.leading.equalTo(authorAvatarImageView.snp.trailing).offset(GlobalConstants.Padding.small)
            $0.trailing.equalTo(containerView.snp.trailing).inset(GlobalConstants.Padding.medium)
        }
        
        postTextLabel.snp.makeConstraints {
            $0.top.equalTo(authorAvatarImageView.snp.bottom).offset(GlobalConstants.Padding.small)
            $0.leading.equalTo(containerView.snp.leading).offset(GlobalConstants.Padding.padding)
            $0.trailing.equalTo(containerView.snp.trailing).inset(GlobalConstants.Padding.padding)
        }
        
        postImageView.snp.makeConstraints {
            $0.top.equalTo(postTextLabel.snp.bottom).offset(GlobalConstants.Padding.small)
            $0.leading.equalTo(containerView.snp.leading).offset(GlobalConstants.Padding.padding)
            $0.trailing.equalTo(containerView.snp.trailing).inset(GlobalConstants.Padding.padding)
            $0.height.equalTo(postImageView.snp.width)
        }
        
        postLikeView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(GlobalConstants.Padding.small)
            $0.leading.equalTo(containerView.snp.leading).offset(GlobalConstants.Padding.padding)
            $0.bottom.equalTo(containerView.snp.bottom).inset(GlobalConstants.Padding.medium)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PostDetailsViewController {
    
    @objc func closeButtonHandler() {
        viewModel.close()
    }
    
}
