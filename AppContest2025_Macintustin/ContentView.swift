//
//  ContentView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    tabLabel("Home", systemImage: "house.fill")
                }
                .tag(0)
            RecommendationView()
                .tabItem {
                    tabLabel("Recommendation", systemImage: "hand.thumbsup.fill")
                }
                .tag(1)
            UserView()
                .tabItem {
                    tabLabel("User", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.blue)
        .background(.ultraThinMaterial)
    }
    
    private func tabLabel(_ text: String, systemImage: String) -> some View {
        VStack {
            Image(systemName: systemImage)
            Text(text)
                .font(.headline)
        }
    }
}

//#Preview {
//    ContentView()
//}
