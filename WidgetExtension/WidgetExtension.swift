//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Jim Huang on 2025/5/15.
//

import WidgetKit
import SwiftUI

//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//
////    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}

struct WidgetExtensionProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
//    let configuration: ConfigurationAppIntent
}

struct WidgetExtensionEntryView : View {
    var entry: WidgetExtensionProvider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetExtensionProvider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetExtensionEntryView(entry: entry)
                    .containerBackground(.fill, for: .widget)
                    .background(Color.white)
            } else {
                WidgetExtensionEntryView(entry: entry)
                    .background(Color.white)
            }
        }
//        .contentMarginsDisabled()
//        .configurationDisplayName("家樂福")
//        .description("")
//        .supportedFamilies([.systemMedium])

//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            WidgetExtensionEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
    }
}

//#Preview(as: .systemSmall) {
//    WidgetExtension()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
