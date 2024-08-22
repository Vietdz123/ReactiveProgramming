//
//  Extension+View.swift
//  eWidget
//
//  Created by MAC on 05/12/2023.
//

import SwiftUI
import Combine
import GoogleMobileAds

struct AdaptedKeyBoard<Content: View>: View {
    
    let content: Content
    @Binding var id: Int
    
    init(id: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._id = id
    }

    var body: some View {
        ScrollViewReader { proxy in
            content
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .top)
                        }
                        
                        print("DEBUG: keyboard keyboardWillShowNotification")
                    }
                }
        }
    }
}

extension View {
    
    var heightAdaptiveBannerAds: CGFloat {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(widthDevice).size.height
    }
    
    var widthDevice: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var heightDevice: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    var topSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }


    
}








