//
//  ContentFilter.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import Foundation

class ContentFilter {
    // Keywords and patterns that indicate explicit content
    private let blockedKeywords: [String] = [
        "porn", "xxx", "adult", "sex", "nude", "naked", "explicit",
        "erotic", "mature", "nsfw", "dating", "hookup", "escort",
        "casino", "gambling", "betting", "poker", "lottery"
    ]
    
    // Blocked domains (can be expanded)
    private let blockedDomains: [String] = [
        "pornhub", "xvideos", "xhamster", "redtube", "youporn",
        "porn", "xxx", "adult"
    ]
    
    func shouldBlock(url: String) -> Bool {
        let lowercasedURL = url.lowercased()
        
        // Check blocked domains
        for domain in blockedDomains {
            if lowercasedURL.contains(domain) {
                return true
            }
        }
        
        // Check blocked keywords in URL
        for keyword in blockedKeywords {
            if lowercasedURL.contains(keyword) {
                return true
            }
        }
        
        return false
    }
    
    func isSafeURL(_ url: String) -> Bool {
        return !shouldBlock(url: url.lowercased())
    }
}
