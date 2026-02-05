//
//  WebView.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var url: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    @Binding var currentURL: String
    var onBlockedContent: (String) -> Void
    var navigationAction: NavigationAction = .none
    
    enum NavigationAction: Equatable {
        case none
        case back
        case forward
        case refresh
        case stop
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        context.coordinator.webView = webView
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Handle navigation actions
        switch navigationAction {
        case .back:
            if webView.canGoBack {
                webView.goBack()
            }
        case .forward:
            if webView.canGoForward {
                webView.goForward()
            }
        case .refresh:
            webView.reload()
        case .stop:
            webView.stopLoading()
        case .none:
            break
        }
        
        // Handle URL changes - only load if URL is different and valid
        guard let newURL = URL(string: url), url.isEmpty == false else {
            return
        }
        
        let currentURLString = webView.url?.absoluteString ?? ""
        let newURLString = newURL.absoluteString
        
        // Only load if URLs are different and we're not in the middle of navigation
        if newURLString != currentURLString && navigationAction == .none {
            let request = URLRequest(url: newURL)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        let contentFilter: ContentFilter
        weak var webView: WKWebView?
        
        init(_ parent: WebView) {
            self.parent = parent
            self.contentFilter = ContentFilter()
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.currentURL = webView.url?.absoluteString ?? ""
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.currentURL = webView.url?.absoluteString ?? ""
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            let urlString = url.absoluteString.lowercased()
            
            // Check if content should be blocked
            if contentFilter.shouldBlock(url: urlString) {
                DispatchQueue.main.async {
                    self.parent.onBlockedContent(urlString)
                }
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
    }
}
