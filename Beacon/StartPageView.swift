//
//  StartPageView.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import SwiftUI

struct StartPageView: View {
    var onSearch: (String) -> Void
    @State private var searchQuery: String = ""
    @FocusState private var isSearchFocused: Bool
    
    let quickLinks = [
        ("Google", "https://www.google.com", "magnifyingglass"),
        ("Wikipedia", "https://www.wikipedia.org", "book"),
        ("YouTube", "https://www.youtube.com", "play.rectangle"),
        ("News", "https://news.google.com", "newspaper")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.15, blue: 0.25),
                    Color(red: 0.15, green: 0.2, blue: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Beacon logo and welcome
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.7, blue: 0.2),
                                            Color(red: 1.0, green: 0.9, blue: 0.4)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: Color(red: 1.0, green: 0.7, blue: 0.2).opacity(0.5), radius: 20)
                            
                            LighthouseLogo(size: 70)
                        }
                        
                        Text("Beacon")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Safe Browsing for Everyone")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Search bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                            .font(.system(size: 18))
                        
                        TextField("Search the web", text: $searchQuery)
                            .textFieldStyle(.plain)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .keyboardType(.webSearch)
                            .submitLabel(.search)
                            .focused($isSearchFocused)
                            .onSubmit {
                                if !searchQuery.isEmpty {
                                    onSearch(searchQuery)
                                }
                            }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.7, blue: 0.2).opacity(0.4),
                                                Color(red: 1.0, green: 0.9, blue: 0.4).opacity(0.3)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                    )
                    .padding(.horizontal, 24)
                    
                    // Safety badge
                    HStack(spacing: 12) {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Protected by Beacon")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Explicit content is automatically blocked")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal, 24)
                    
                    // Quick links
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Links")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(quickLinks, id: \.0) { link in
                                Button(action: {
                                    onSearch(link.1)
                                }) {
                                    VStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white.opacity(0.15))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: link.2)
                                                .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                                                .font(.system(size: 24))
                                        }
                                        
                                        Text(link.0)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    StartPageView(onSearch: { _ in })
}
