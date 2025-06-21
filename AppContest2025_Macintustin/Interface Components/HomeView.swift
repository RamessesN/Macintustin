/**
 @file HomeView.swift
 @project AppContest2025_Macintustin
 
 @brief The main interface view is applied to provide the switch between AR and MAP view.
 @details
   HomeView is the main view users see when they enter the app, which contains a Segmented Picker and allows users to switch between "AR view" and "Map view".
   - AR View: Shows ARKit-based augmented reality content.
   - Map View: Shows a flat map view based on MapKit.
 
 @author 赵禹惟
 @date 2025/4/16
 */

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var selectedView: ViewType = .ar
    
    enum ViewType: String, CaseIterable, Identifiable {
        case ar = "AR View"
        case map = "Map View"
            
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
            
            if selectedView == .ar {
                AugmentedRealityView()
                    .transition(.opacity)
            } else {
                PlainView()
                    .transition(.opacity)
            }
        }
    }
}
