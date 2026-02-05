//
//  BrowserView.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import SwiftUI
import WebKit

struct BrowserView: View {
    @State private var urlString: String = ""
    @State private var currentURL: String = ""
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @State private var isLoading: Bool = false
    @State private var showBlockedAlert: Bool = false
    @State private var blockedURL: String = ""
    @State private var isEditingURL: Bool = false
    @FocusState private var isURLFocused: Bool
    @State private var navigationAction: WebView.NavigationAction = .none
    @State private var showStartPage: Bool = true
    
    var body: some View {
        ZStack {
            // Background gradient - lighthouse theme
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.15, blue: 0.25), // Dark blue
                    Color(red: 0.15, green: 0.2, blue: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top navigation bar with lighthouse theme
                topNavigationBar
                
                // Start page or Web view
                if showStartPage && urlString.isEmpty {
                    StartPageView(onSearch: { query in
                        navigateToQuery(query)
                    })
                } else {
                    WebView(
                        url: $urlString,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        isLoading: $isLoading,
                        currentURL: $currentURL,
                        onBlockedContent: { blockedURL in
                            self.blockedURL = blockedURL
                            showBlockedAlert = true
                        },
                        navigationAction: navigationAction
                    )
                    .background(Color.white)
                    .onChange(of: navigationAction) { oldValue, newValue in
                        // Reset action after it's been processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if navigationAction != .none {
                                navigationAction = .none
                            }
                        }
                    }
                    .onChange(of: currentURL) { oldValue, newValue in
                        if newValue.isEmpty {
                            showStartPage = true
                        } else {
                            showStartPage = false
                        }
                    }
                }
            }
        }
        .alert("Content Blocked", isPresented: $showBlockedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This content has been blocked by Beacon's safety filters to protect you from explicit or inappropriate material.")
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        VStack(spacing: 0) {
            // Beacon logo and title area
            HStack {
                // Lighthouse logo with gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.7, blue: 0.2), // Orange
                                    Color(red: 1.0, green: 0.9, blue: 0.4)  // Yellow
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    LighthouseLogo(size: 28)
                }
                
                Text("Beacon")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Safety indicator
                HStack(spacing: 4) {
                    Image(systemName: "shield.checkered")
                        .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                        .font(.system(size: 16))
                    Text("Protected")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.12, green: 0.18, blue: 0.28),
                        Color(red: 0.1, green: 0.15, blue: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // URL Bar
            HStack(spacing: 12) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                    .font(.system(size: 16))
                
                TextField(showStartPage ? "Search or enter website" : (currentURL.isEmpty ? "Search or enter website" : currentURL), text: $urlString)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.webSearch)
                    .submitLabel(.go)
                    .focused($isURLFocused)
                    .onSubmit {
                        navigateToURL()
                    }
                    .onTapGesture {
                        if !showStartPage && !currentURL.isEmpty {
                            urlString = currentURL
                        }
                    }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 1.0, green: 0.7, blue: 0.2)))
                        .scaleEffect(0.8)
                } else if !showStartPage && !currentURL.isEmpty {
                    Button(action: {
                        urlString = currentURL
                        isURLFocused = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.7, blue: 0.2).opacity(0.3),
                                        Color(red: 1.0, green: 0.9, blue: 0.4).opacity(0.2)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.18, blue: 0.28),
                    Color(red: 0.1, green: 0.15, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - Navigation Functions
    private func navigateToURL() {
        isURLFocused = false
        showStartPage = false
        var url = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if url.isEmpty {
            showStartPage = true
            return
        }
        
        // Add https:// if no scheme is present
        if !url.contains("://") {
            if url.contains(".") && !url.contains(" ") {
                url = "https://" + url
            } else {
                // Treat as search query
                navigateToQuery(url)
                return
            }
        }
        
        urlString = url
    }
    
    private func navigateToQuery(_ query: String) {
        showStartPage = false
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        urlString = "https://www.google.com/search?q=\(encodedQuery)"
    }
    
    private func goBack() {
        navigationAction = .back
    }
    
    private func goForward() {
        navigationAction = .forward
    }
    
    private func refreshOrStop() {
        if isLoading {
            navigationAction = .stop
        } else {
            navigationAction = .refresh
        }
    }
    
    private func goHome() {
        urlString = ""
        showStartPage = true
        currentURL = ""
    }
}

#Preview {
    BrowserView()
}
