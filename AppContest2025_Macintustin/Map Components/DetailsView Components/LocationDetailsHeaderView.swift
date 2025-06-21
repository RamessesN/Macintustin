/**
 @file LocationDetailsHeaderView.swift
 @project AppContest2025_Macintustin
 
 @brief A header view displaying the name and title of a location.
 @details
  LocationDetailsHeaderView is a compact SwiftUI view used as a header or title
  section in detailed location-related screens. It takes in a `placemarkName`
  and a `placemarkTitle`, and displays them vertically aligned within a `HStack`.

  The placemark name is shown prominently using a semibold title font, while the
  title is rendered in smaller, gray-colored text below it. The layout handles
  long names gracefully by allowing multiple lines and fixed vertical sizing.

  This component is designed for reuse in contexts like location detail pages,
  annotation popups, or list headers, providing a clean and consistent visual identity
  for named locations.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct LocationDetailsHeaderView: View {
    var placemarkName: String
    var placemarkTitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(placemarkName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(placemarkTitle)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .padding(.trailing)
            }
            .padding(.leading)
        }
    }
}
