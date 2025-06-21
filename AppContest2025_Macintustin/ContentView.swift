/**
 @file ContentView.swift
 @project AppContest2025_Macintustin
 
 @brief Main tab-based container view for the application.
 @details
  ContentView provides the primary navigation structure for the app using a bottom `TabView`.
  It consists of three core sections:

  - `HomeView`: A view switcher between AR and map interfaces
  - `RecommendationView`: A view displaying the top liked locations
  - `UserView`: A personal profile screen allowing name editing and image uploading

  The `tabLabel` helper function creates consistent tab item labels with icons and styled text.
  The selected tab is tinted blue, and the tab bar background is rendered with a translucent
  material for a modern visual effect.

  This view acts as the root container for the app's main functionality after launch.

 
 @author 赵禹惟
 @date 2025/4/16
 */

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
