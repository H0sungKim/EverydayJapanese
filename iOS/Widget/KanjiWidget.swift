//
//  Widget.swift
//  Widget
//
//  Created by 김호성 on 2025.09.01.
//

import WidgetKit
import SwiftUI

struct KanjiProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> KanjiSimpleEntry {
        KanjiSimpleEntry(date: Date(), configuration: KanjiConfigurationAppIntent())
    }

    func snapshot(for configuration: KanjiConfigurationAppIntent, in context: Context) async -> KanjiSimpleEntry {
        KanjiSimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: KanjiConfigurationAppIntent, in context: Context) async -> Timeline<KanjiSimpleEntry> {
        var entries: [KanjiSimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = KanjiSimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct KanjiSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: KanjiConfigurationAppIntent
}

struct KanjiWidgetEntryView : View {
    var entry: KanjiProvider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    @State private var kanjis: [Kanji] = []
    
    var index: Int? {
        switch entry.configuration.updateInterval {
        case .day:
            return Calendar.current.dateComponents([.day], from: .distantPast, to: entry.date).day
        case .hour:
            return  Calendar.current.dateComponents([.hour], from: .distantPast, to: entry.date).hour
        }
    }
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
            systemWidget
        case .accessoryRectangular:
            accessoryWidget
        default:
            EmptyView()
        }
    }
    
    private var systemWidget: some View {
        VStack {
            if let kanji = displayKanji {
                Text(kanji.jpSound)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .font(Font.system(size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(kanji.jpMeaning)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .font(Font.system(size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(AttributedString(getAttrributedString(from: kanji.kanji)))
                    .font(Font.system(size: 64))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(kanji.eumhun)
                    .font(Font.system(size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }.onAppear(perform: {
            loadData()
        })
    }
    
    private var accessoryWidget: some View {
        HStack {
            if let kanji = displayKanji {
                Text(AttributedString(getAttrributedString(from: kanji.kanji)))
                    .font(Font.system(size: 64))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                VStack {
                    Text(kanji.jpSound)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                        .font(Font.system(size: 12))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(kanji.jpMeaning)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                        .font(Font.system(size: 12))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(kanji.eumhun)
                        .font(Font.system(size: 14))
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                }
            }
        }.onAppear(perform: {
            loadData()
        })
    }
    
    private var displayKanji: Kanji? {
        guard !kanjis.isEmpty else { return nil }
        return kanjis[(index ?? 0) % kanjis.count]
    }
    
    private func getAttrributedString(from text: String) -> NSMutableAttributedString {
        let nsAttributedString = NSMutableAttributedString(string: text)
        nsAttributedString.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: text.count))
        return nsAttributedString
    }
    
    private func loadData() {
        let studyPart = entry.configuration.studyPart
        let dict = JSONManager.shared.decode(data: JSONManager.shared.openJSON(path: "kanji"), type: [String: Kanji].self) ?? [:]
        kanjis = studyPart.idRange.compactMap({ dict[$0] })
    }
}

struct KanjiWidget: Widget {
    let kind: String = "KanjiWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: KanjiConfigurationAppIntent.self, provider: KanjiProvider()) { entry in
            KanjiWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("상용한자")
        .description("일본 상용한자 2136자를 표시합니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

extension KanjiConfigurationAppIntent {
    fileprivate static var kanjiBookmark: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiBookmark
        return intent
    }
    fileprivate static var kanjiElementary1: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary1
        return intent
    }
    fileprivate static var kanjiElementary2: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary2
        return intent
    }
    fileprivate static var kanjiElementary3: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary3
        return intent
    }
    fileprivate static var kanjiElementary4: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary4
        return intent
    }
    fileprivate static var kanjiElementary5: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary5
        return intent
    }
    fileprivate static var kanjiElementary6: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiElementary6
        return intent
    }
    fileprivate static var kanjiMiddle: KanjiConfigurationAppIntent {
        let intent = KanjiConfigurationAppIntent()
        intent.studyPart = .kanjiMiddle
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    KanjiWidget()
} timeline: {
    KanjiSimpleEntry(date: .now, configuration: .kanjiElementary6)
}
