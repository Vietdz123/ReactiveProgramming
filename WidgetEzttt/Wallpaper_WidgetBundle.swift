//
//  Wallpaper_WidgetBundle.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import SwiftUI
import WidgetKit


@main
@available(iOS 17.0, *)
struct Wallpaper_WidgetBundle: WidgetBundle {
    
    var body: some Widget {
        WallpaperWidget()
       
       
    }
  
    
}

@available(iOS 17.0, *)
struct WallpaperWidget: Widget {
    let kind: String = "WallpaperWidget"

    
    var body: some WidgetConfiguration {


            AppIntentConfiguration(kind: kind,
                                   intent: ConfigurationAppIntent.self,
                                   provider: Provider()) { entry in
                WallpaperWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            }
                                   .contentMarginsDisabled()
                                   .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])


    }
}



struct ProviderFor16: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct AAAAEntryView : View {
    var entry: ProviderFor16.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct AAAA: Widget {
    let kind: String = "AAAA"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProviderFor16()) { entry in
         
                AAAAEntryView(entry: entry)
                    .padding()
                    .background()
           
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
