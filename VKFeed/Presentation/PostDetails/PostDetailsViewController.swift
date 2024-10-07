//
//  PostDetailsViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import Combine
import SnapKit

protocol PostDetailsDelegate: AnyObject {
    func didUpdatePost(_ post: Post)
}

final class PostDetailsViewController: UIViewController {
    
    private struct Constans {
        static let avatarSize: CGFloat = 48
        static let tinyPadding: CGFloat = 4
    }
    
    private var post: Post
    private let viewModel: PostDetailsViewModel
    
    public weak var delegate: PostDetailsDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    private var authorAvatarImageView = VKImageView(contentMode: .scaleAspectFill)
    private var authorNameLabel = VKLabel(style: .headline, weight: .semibold)
    private var postDateLabel = VKLabel(style: .footnote, color: .secondaryLabel)
    private var postTextLabel = VKLabel(style: .subheadline)
    private var postImageView = VKImageView(contentMode: .scaleAspectFill)
    private lazy var postLikeView = PostLikeView(post)
    
    init(_ post: Post,
         viewModel: PostDetailsViewModel) {
        self.post = post
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupViews()
        setupPost()
        layout()
    }
    
    
    private func bindViewModel() {
        viewModel.postPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] post in
                guard let self else { return }
                updatePost(post)
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] errorMessage in
                guard let self else { return }
                if let errorMessage { presentAlert(message: errorMessage) }
            }
            .store(in: &cancellables)
    }
    
    
    private func updatePost(_ post: Post) {
        let isOldPost = self.post == post
        
        self.post = post
        
        if isOldPost {
            postLikeView.revertLike()
        } else {
            delegate?.didUpdatePost(post)
        }
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
        
        postLikeView.delegate = self
    }
    
    
    private func setupPost() {
        authorAvatarImageView.setImage(from: post.author?.photoURL, placeholder: .profileImagePlaceholder)
        
        authorNameLabel.text = post.author?.name
        
        postDateLabel.text = post.createdAt.toPostDateFormat()
        
        postTextLabel.text = post.text
        
        if let photoURL = post.photoURL {
            postImageView.setImage(from: photoURL, placeholder: .postPlaceholder)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
    
    
    private func layout() {
        let postHasImage = postImageView.image != nil
        
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
        
        if postHasImage {
            postImageView.snp.makeConstraints {
                $0.top.equalTo(postTextLabel.snp.bottom).offset(GlobalConstants.Padding.small)
                $0.leading.equalTo(containerView.snp.leading).offset(GlobalConstants.Padding.padding)
                $0.trailing.equalTo(containerView.snp.trailing).inset(GlobalConstants.Padding.padding)
                $0.height.equalTo(postImageView.snp.width)
            }
            
            postLikeView.snp.makeConstraints {
                $0.top.equalTo(postImageView.snp.bottom).offset(GlobalConstants.Padding.small)
            }
        } else {
            postLikeView.snp.makeConstraints {
                $0.top.equalTo(postTextLabel.snp.bottom).offset(GlobalConstants.Padding.small)
            }
        }
        
        postLikeView.snp.makeConstraints {
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


extension PostDetailsViewController: PostLikeDelegate {
    
    func didToggleLike(for post: Post) {
        viewModel.toggleLike(for: post)
    }
    
}
