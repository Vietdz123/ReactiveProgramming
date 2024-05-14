//
//  LockInlineWidget.swift
//  eWidget
//
//  Created by MAC on 04/01/2024.
//

import WidgetKit
import SwiftUI
import AVFoundation

@available(iOS 17.0, *)
struct LockInlineWidget: Widget {
    let kind: String = "LockInlineWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LockInlineConfigurationAppIntent.self,
                               provider: InlineProvider()) { entry in
            InlineWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .accessoryInline ])
        .configurationDisplayName("Lock Widget")
        .description("Add the desired widget size to your Lock Screen.")
        
    }
}

struct LockInlineWidgetIOS16: Widget {

    let kind: String = "LockInlineWidgetIOS16"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: LockInlineConfigurationAppIntentIOS16Intent.self,
                            provider: InlineProviderIOS16(),
                            content: { entry in
            InlineWidgetView(entry: entry)
                            }
        )
        .contentMarginsDisabled()
        .supportedFamilies([ .accessoryInline ])
        .configurationDisplayName("Lock Widget")
        .description("Add the desired widget size to your Lock Screen.")
    }
}

