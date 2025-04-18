//
//  HomeView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/16.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var selectedView: ViewType = .map
    
    enum ViewType: String, CaseIterable, Identifiable {
        case map = "Map View"
        case ar = "AR View"
            
        var id: Self { self }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Picker("Select View", selection: $selectedView) {
                    ForEach(ViewType.allCases) { viewType in
                        Text(viewType.rawValue)
                            .tag(viewType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 20)
                .padding(.leading, 60)
                .padding(.trailing, 60)
                
                Spacer()
            }
            .zIndex(1)
            
            if selectedView == .map {
                PlainView()
                    .transition(.opacity)
            } else {
                ARView()
                    .transition(.opacity)
                    .ignoresSafeArea(.all)
            }
        }
    }
}
