//
//  Wallpaper_WidgetBundle.swift
//  Wallpaper-Widget
//
//  Created by MAC on 19/10/2023.
//

import WidgetKit
import SwiftUI
import AVFoundation


@available(iOS 17.0, *)
struct WidgetEzttt: Widget {
    let kind: String = "WidgetEzttt"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: HomeProvider()) { entry in
            WallpaperWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemMedium, .systemLarge,  .systemSmall,])
        .configurationDisplayName("Interact Widget")
        
    }
}
