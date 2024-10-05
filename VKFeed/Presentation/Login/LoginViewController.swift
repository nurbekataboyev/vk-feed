//
//  LoginViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import Combine
import SnapKit

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var loginButton = VKButton(title: "Continue with VK", backgroundColor: .vkPrimary)
    private lazy var loadingView = VKLoadingView(viewController: self)
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupViews()
        layout()
    }
    
    
    private func bindViewModel() {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? loadingView.showLoadingView() : loadingView.dismissLoadingView()
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
    
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
    }
    
    
    private func layout() {
        loginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(GlobalConstants.Padding.extraLarge)
            $0.height.equalTo(GlobalConstants.Height.buttonHeight)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension LoginViewController {
    
    @objc func loginHandler() {
        viewModel.startAuthentication()
    }
    
}
