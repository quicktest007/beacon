//
//  ContentView.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BrowserView()
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
