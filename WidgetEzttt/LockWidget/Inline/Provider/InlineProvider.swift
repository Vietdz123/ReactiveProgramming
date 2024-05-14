//
//  SquareProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI
import WidgetKit


@available(iOSApplicationExtension 17.0, *)
struct InlineProvider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> InlineEntry {
        InlineEntry(date: .now, size: context.displaySize, imgSrc: InlineSource(id: "choose", actualName: "choose"), title: "Have a good day")
    }

    func snapshot(for configuration: LockInlineConfigurationAppIntent, in context: Context) async -> InlineEntry {
        InlineEntry(date: .now, size: context.displaySize, imgSrc: InlineSource(id: "choose", actualName: "choose"), title: "Have a good day")
    }
    
    func timeline(for configuration: LockInlineConfigurationAppIntent, in context: Context) async -> Timeline<InlineEntry> {

        let inlineSource = configuration.imageSrc
        let title = configuration.imageSrc.getCategory()?.titleQuote ?? "Have a good day"
        let entry = InlineEntry(date: .now, size: context.displaySize, imgSrc: inlineSource, title: title)
        return Timeline(entries: [entry], policy: .never)
    }
}



struct InlineProviderIOS16: IntentTimelineProvider {
    func placeholder(in context: Context) -> InlineEntry {
        return InlineEntry(date: .now, size: context.displaySize, imgSrc: InlineSource(id: "choose", actualName: "choose"), title: "Have a good day")
    }
    
    func getSnapshot(for configuration: LockInlineConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (InlineEntry) -> Void) {
        completion(InlineEntry(date: .now, size: context.displaySize, imgSrc: InlineSource(id: "choose", actualName: "choose"), title: "Have a good day"))
    }
    
    func getTimeline(for configuration: LockInlineConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (Timeline<InlineEntry>) -> Void) {
        
        let inlineSource: InlineSource = .UnwrappedType(id: configuration.name ?? "", actualName: configuration.name ?? "")
        let title = inlineSource.getCategory()?.titleQuote ?? "Have a good day"
        let entry = InlineEntry(date: .now, size: context.displaySize, imgSrc: inlineSource, title: title)
         completion(Timeline(entries: [entry], policy: .never))
    }
    
}
