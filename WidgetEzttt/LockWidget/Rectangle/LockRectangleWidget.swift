//
//  LockRectAndSquareWidget.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import WidgetKit
import SwiftUI
import AVFoundation

@available(iOS 17.0, *)
struct LockRectangleWidget: Widget {
    let kind: String = "LockRectangleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LockRectangleConfigurationAppIntent.self,
                               provider: RectangleProvider()) { entry in
            RectangleWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .accessoryRectangular ])
        
    }
}


struct LockRectangleWidgetIOS16: Widget {

    let kind: String = "LockRectangleWidgetIOS16"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: LockRectangleConfigurationAppIntentIOS16Intent.self,
                            provider: RectangleLockProviderIOS16(),
                            content: { entry in
            RectangleWidgetView(entry: entry)
                            }
        )
        .contentMarginsDisabled()
        .supportedFamilies([ .accessoryRectangular ])
        .configurationDisplayName("Lock Widget")
        .description("Add the desired widget size to your Lock Screen.")
    }
}
