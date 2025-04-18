//
//  ARView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI

struct ARView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Text("ARView")
                    .font(.largeTitle)
                    .padding()
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}
