/**
 @file StartView.swift
 @project AppContest2025_Macintustin
 
 @brief Startup screen
 @details
  StartView serves as the animated splash screen for the application. It displays a globe icon
  and the title “Cairo World” with fade-in and scaling animations on launch. A brief footer note
  indicates the app is developed by Macintustin.

  The animation includes:
  - A scaling and fading globe icon
  - A sliding and fading text title
  - A delay before transitioning into the main `ContentView`

  After a total duration of 3.5 seconds, the view automatically transitions to the main app interface
  using a smooth opacity-based animation. This view enhances user experience by providing a
  branded and visually appealing entry point to the app.
 
 @author 赵禹惟
 @date 2025/4/16
 */

import SwiftUI

struct StartView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 1.5
    @State private var offsetY: CGFloat = 20
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            if !isActive {
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        Image(systemName: "globe.asia.australia.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(opacity)
                            .scaleEffect(scale)
                            .onAppear {
                                withAnimation(.easeIn(duration: 1.5)) {
                                    opacity = 1.0
                                    scale = 1.0
                                }
                            }
                        
                        Text("Cairo World")
                            .font(.custom("Times New Roman", size: 40))
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(opacity)
                            .offset(y: offsetY)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 2.5)) {
                                        opacity = 1.0
                                        offsetY = 0
                                    }
                                }
                            }
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    Text("Macintustin 独家服务")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 20)
                }
            }
            
            if isActive {
                ContentView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: isActive)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = true
                }
            }
        }
    }
}
