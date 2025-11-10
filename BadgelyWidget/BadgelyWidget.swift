//
//  BadgelyWidget.swift
//  BadgelyWidget
//
//  Created by Carolina Nicole Gonzalez Leal on 20/10/25.
//

import WidgetKit
import SwiftUI
import SwiftData
import UIKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    name: "Ejemplo",
                    photo: UIImage(systemName: "photo")!.pngData()!,
                    badgeName: "badge200",
                    place: "Sin lugar")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if let photo = fetchPhotos().first {
            completion(SimpleEntry(date: Date(),
                                   name: photo.name,
                                   photo: photo.photo,
                                   badgeName: photo.badgeName ?? "",
                                   place: photo.place))
        } else {
            completion(placeholder(in: context))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        let photos = fetchPhotos()
        
        for minuteOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let photo = photos.isEmpty ? nil : photos[minuteOffset % photos.count]
            let entry = SimpleEntry(date: entryDate,
                                    name: photo?.name ?? "Sin fotos",
                                    photo: photo?.photo ?? UIImage(systemName: "photo")!.pngData()!,
                                    badgeName: photo?.badgeName ?? "",
                                    place: photo?.place ?? "")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchPhotos() -> [Photo] {
        do {
            let schema = Schema([Photo.self])
            let config = ModelConfiguration("group.caroworks.Badgely")
            let container = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(container)
            
            let descriptor = FetchDescriptor<Photo>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            let results = try context.fetch(descriptor)
            
            return results
        } catch {
            return []
        }
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    var name: String
    var photo: Data
    var badgeName: String?
    var respName: String?
    var place: String
    
}

struct BadgelyWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var entry: Provider.Entry
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            let maxWidth: CGFloat = 300
            let resized = UIImage(data: entry.photo)?
                .resized(toWidth: maxWidth, isOpaque: true)
            
            ZStack {
                if let uiImage = resized {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
            }
        case .systemMedium:
            let maxWidth: CGFloat = 500
            let resized = UIImage(data: entry.photo)?
                .resized(toWidth: maxWidth, isOpaque: true)
            if let uiImage = resized {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        default:
            Text("Badgely Widget")
        }
        
        
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(
            width: width,
            height: CGFloat(ceil(width / size.width * size.height))
        )
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

@main
struct BadgelyWidget: Widget {
    let kind: String = "BadgelyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BadgelyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Mis Fotos")
        .description("Muestra las fotos que has tomado en tus lugares.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
