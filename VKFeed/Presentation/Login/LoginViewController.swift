//
//  LoginViewController.swift
//  VKFeed
//
//  Created by Nurbek on 25/09/24.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    
    private func setupViews() {
        let webView = makeWebView()
        view.addSubview(webView)
    }
    
    
    private func makeWebView() -> WKWebView {
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents()
        urlComponents.scheme = VKAuthAPI.scheme
        urlComponents.host = VKAuthAPI.host
        urlComponents.path = VKAuthAPI.path
        
        urlComponents.queryItems = VKAuthAPI.Parameters.toQueryItems()
        
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping @MainActor (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path() == VKAuthAPI.redirectPath,
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        guard let accessToken = getAccessToken(from: fragment) else {
            presentAlert()
            return
        }
        
        viewModel.saveAccessToken(accessToken)
        
        decisionHandler(.cancel)
    }
    
    
    private func getAccessToken(from fragment: String) -> String? {
        let parameters = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, parameter in
                var dictionary = result
                let key = parameter[0]
                let value = parameter[1]
                dictionary[key] = value
                
                return dictionary
            }
        
        return parameters["access_token"]
    }
    
}
