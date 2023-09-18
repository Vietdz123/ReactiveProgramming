//
//  TabScrollView.swift
//  WallpaperIOS
//
//  Created by Mac on 02/08/2023.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct TabScrollView: View {
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
         
               ScrollViewReader { scrollView in
                   ScrollView {
                   VStack {
                       ForEach(0..<100) { index in
                           Text("Item \(index)")
                               .frame(maxWidth: .infinity)
                               .frame(height: 50)
                               .id(index)
                       }
                   }
                   .background(GeometryReader { geometry in
                       Color.clear.onAppear {
                           scrollView.scrollTo(99, anchor: .bottom)
                       }
                       .onChange(of: scrollOffset) { newValue in
                           scrollView.scrollTo(Int(newValue / 50))
                       }
                   })
                   .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                       scrollOffset = value
                   }
               }
           }.overlay(
           
            Text("\(scrollOffset)")
           )
       }
}

struct TabScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TabScrollView()
    }
}
