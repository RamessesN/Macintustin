//
//  StartView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/16.
//

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
