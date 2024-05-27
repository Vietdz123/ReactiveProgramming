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
        .supportedFamilies([ .systemMedium ])
        .configurationDisplayName("Interact Widget")
        .description("Add the desired widget to your Home Screen.")
        
    }
}

@available(iOS 17.0, *)
struct WidgetEztttLarge: Widget {
    let kind: String = "WidgetEztttLarge"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: HomeProvider()) { entry in
            WallpaperWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemLarge ])
        .configurationDisplayName("Interact Widget")
        .description("Add the desired widget to your Home Screen.")
        
    }
}


@available(iOS 17.0, *)
struct WidgetEztttSmall: Widget {
    let kind: String = "WidgetEztttSmall"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: HomeProvider()) { entry in
            WallpaperWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemSmall ])
        .configurationDisplayName("Interact Widget")
        .description("Add the desired widget to your Home Screen.")
    }
}
