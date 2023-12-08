//
//  HealthWidgetBundle.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//


import WidgetKit
import SwiftUI
import AVFoundation


@available(iOS 17.0, *)
struct HealthWidget: Widget {
    let kind: String = "HealthWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: HealthConfigurationAppIntent.self,
                               provider: HealthProvider()) { entry in
            HealthWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemMedium,   .systemSmall])
        .configurationDisplayName("Health Widget")
      
        
    }
}
