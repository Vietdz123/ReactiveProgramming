//
//  WidgetBundle.swift
//  WallPaper-CoreData
//
//  Created by MAC on 17/11/2023.
//

import SwiftUI
import WidgetKit


@main
struct WidgetEztttExtension: WidgetBundle {
    var body: some Widget {

        if #available(iOSApplicationExtension 17.0, *) {
            return WidgetBundleBuilder.buildBlock(WidgetEzttt(),
                                                  HealthWidget(),
                                                  LockRectangleWidgetIOS16(),
                                                  LockSquareWidgetIOS16(),
                                                  LockInlineWidgetIOS16())

           
        } else  {
            return WidgetBundleBuilder.buildBlock(LockRectangleWidgetIOS16(),
                                                  LockSquareWidgetIOS16(),
                                                  LockInlineWidgetIOS16())
        }
        
    }
}   

  
