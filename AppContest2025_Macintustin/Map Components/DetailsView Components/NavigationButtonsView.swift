//
//  NavigationButtonsView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI
import MapKit

struct NavigationButtonsView: View {
    @Binding var routeDisplaying: Bool
    @Binding var show: Bool
    @Binding var getDirections: Bool
    var mapSelection: MKMapItem?
    var cancelNavigation: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            Button {
                if let mapSelection = mapSelection {
                    mapSelection.openInMaps()
                }
            } label: {
                Text("Open in Maps")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 170, height: 48)
                    .background(.green)
                    .cornerRadius(12)
            }
            
            if routeDisplaying {
                Button {
                    cancelNavigation()
                } label: {
                    Text("Cancel Current Trip")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.orange)
                        .cornerRadius(12)
                }
            } else {
                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}
