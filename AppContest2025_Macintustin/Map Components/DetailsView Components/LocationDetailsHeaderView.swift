//
//  LocationDetailsHeaderView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

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
