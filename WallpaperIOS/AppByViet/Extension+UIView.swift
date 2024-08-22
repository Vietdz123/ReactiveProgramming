//
//  Extension+UIView.swift
//  eWidget
//
//  Created by MAC on 06/12/2023.
//

import SwiftUI


extension UIView {
    
    
    var widthDevice: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var heightDevice: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    var topSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }

    
    var titleColor: UIColor {
        UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1)
    }
    
    var backroundColorLottie: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }
    
}

