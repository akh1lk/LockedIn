//
//  WebViewerController.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import WebKit

class WebViewerController: UIViewController {
    
    private let webView = WKWebView()
    private let urlString: String
    
    var onAuthCompletion: ((Result<[String: Any], Error>) -> Void)?

    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        guard let url = URL(string: urlString) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.webView.load(URLRequest(url: url))
    }

    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.view.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    @objc private func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network: Auth Link
    // Capture redirects and check for the "/auth" endpoint
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.path == "/auth" {
            handleAuthRedirect(url: url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    private func handleAuthRedirect(url: URL) {
        // Parse the auth token or handle backend response
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.onAuthCompletion?(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                self?.onAuthCompletion?(.failure(NSError(domain: "AuthError", code: -1, userInfo: nil)))
                return
            }
            
            DispatchQueue.main.async {
                self?.onAuthCompletion?(.success(json))
                self?.dismiss(animated: true, completion: nil)
            }
        }.resume()
    }
}
