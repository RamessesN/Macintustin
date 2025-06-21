/**
 @file NavigationButtonsView.swift
 @project AppContest2025_Macintustin
 
 @brief A view providing navigation control buttons for map-based directions.
 @details
  NavigationButtonsView is a SwiftUI component that offers users a set of buttons
  for interacting with map-based navigation. Depending on the current navigation state,
  the view conditionally displays buttons to:

  - Open the selected destination in Apple Maps using `MKMapItem.openInMaps()`
  - Cancel an ongoing trip via a callback function
  - Trigger route generation by toggling `getDirections`

  The view adapts dynamically based on the `routeDisplaying` flag and manages
  interaction flow through bindings to external state variables (`show`, `getDirections`).

  It's designed to integrate into a map-based location detail interface, allowing
  flexible control over navigation and routing behavior.
 
 @author 赵禹惟
 @date 2025/4/18
 */

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
