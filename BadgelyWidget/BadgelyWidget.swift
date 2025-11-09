//
//  BadgelyWidget.swift
//  BadgelyWidget
//
//  Created by Carolina Nicole Gonzalez Leal on 20/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), name: "", badgeName: "", place: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), name: "", badgeName: "", place: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, name: "", badgeName: "", place: "")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    var name: String
    //var photo: Data
    var badgeName: String?
    var place: String
    
}

struct BadgelyWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var entry: Provider.Entry

    var body: some View {
        
        VStack {
            Text("Some other WidgetFamily in the future.")
        }
    }
}

struct BadgelyWidget: Widget {
    let kind: String = "BadgelyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BadgelyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BadgelyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    BadgelyWidget()
} timeline: {
    SimpleEntry(date: .now,
                name: "Atardecer",
               // photo: UIImage(systemName: "sunset.fill")!.pngData()!,
                badgeName: "Nature",
                place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910"
    )
}
