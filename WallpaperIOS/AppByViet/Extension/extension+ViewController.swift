//
//  extensioViewController.swift
//  eWidget
//
//  Created by MAC on 06/12/2023.
//

import SwiftUI

extension UIViewController {
    
    var widthDevice: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var heightDevice: CGFloat {
        return UIScreen.main.bounds.height
    }
    

    
    
    var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    var insetTop: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        }
        
        return 0
    }
    
}
