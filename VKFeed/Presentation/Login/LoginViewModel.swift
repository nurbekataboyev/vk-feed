//
//  LoginViewModel.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import Foundation
import Combine
import AuthenticationServices

protocol LoginViewModel {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    func startAuthentication()
}

final class LoginViewModelImpl: NSObject, LoginViewModel {
    
    // internal
    private let authenticationUseCase: AuthenticationUseCase
    private let router: LoginRouter
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var isLoading: Bool = false
    @Published private var errorMessage: String? = nil
    
    // external
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return $isLoading.eraseToAnyPublisher()
    }
    
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        return $errorMessage.eraseToAnyPublisher()
    }
    
    init(authenticationUseCase: AuthenticationUseCase,
         router: LoginRouter) {
        self.authenticationUseCase = authenticationUseCase
        self.router = router
    }
    
    
    public func startAuthentication() {
        isLoading = true
        
        let codeVerifier = AuthenticationHelper.generateCodeVerifier()
        let codeChallenge = AuthenticationHelper.generateCodeChallenge(from: codeVerifier)
        
        let request = API.Request(
            scheme: VKIDAPI.scheme,
            host: VKIDAPI.host,
            path: VKIDAPI.Paths.authorize().path,
            method: .POST,
            parameters: VKIDAPI.Paths.authorize(codeChallenge: codeChallenge).parameters())
            .createURLRequest()
        
        guard let url = request?.url else {
            handleError(VKError.Network.invalidURL)
            return
        }
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: VKConfig.callbackURL) { [weak self] callbackURL, error in
            guard let self else { return }
            
            guard let callbackURL, error == nil else {
                handleError(VKError.Login.loginFailed)
                return
            }
            
            handleCallbackURL(callbackURL, codeVerifier: codeVerifier)
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    
    private func handleCallbackURL(_ callbackURL: URL, codeVerifier: String) {
        guard let code = callbackURL.queryParameters["code"],
              let deviceID = callbackURL.queryParameters["device_id"] else {
            handleError(VKError.Token.invalidToken)
            return
        }
        
        authenticationUseCase.authenticate(withCode: code, deviceID: deviceID, codeVerifier: codeVerifier)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] authResponse in
                guard let self else { return }
                
                authenticationUseCase.saveAccessToken(authResponse.accessToken, expiresIn: authResponse.expiresIn)
                
                DispatchQueue.main.async {
                    self.router.setNewsFeed()
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
    }
    
}


extension LoginViewModelImpl: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIWindow()
    }
    
}
