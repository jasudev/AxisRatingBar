//
//  ContentView.swift
//  AxisRatingBarExample
//
//  Created by jasu on 2022/02/20.
//  Copyright (c) 2022 jasu All rights reserved.
//

import SwiftUI
import AxisRatingBar

struct ContentView: View {
    
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            CustomRatingBar(axisMode: .horizontal)
                .tag(0)
                .tabItem {
                    Image(systemName: "square.split.2x1.fill")
                    Text("Horizontal")
                }
            CustomRatingBar(axisMode: .vertical)
                .tag(1)
                .tabItem {
                    Image(systemName: "square.split.1x2.fill")
                    Text("Vertical")
                }
                
        }
#if os(macOS)
        .padding()
#endif
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
