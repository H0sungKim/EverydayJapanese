//
//  Widget.swift
//  Widget
//
//  Created by 김호성 on 2025.09.01.
//

import WidgetKit
import SwiftUI

struct JLPTProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> JLPTSimpleEntry {
        JLPTSimpleEntry(date: Date(), configuration: JLPTConfigurationAppIntent())
    }

    func snapshot(for configuration: JLPTConfigurationAppIntent, in context: Context) async -> JLPTSimpleEntry {
        JLPTSimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: JLPTConfigurationAppIntent, in context: Context) async -> Timeline<JLPTSimpleEntry> {
        var entries: [JLPTSimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = JLPTSimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct JLPTSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: JLPTConfigurationAppIntent
}

struct JLPTWidgetEntryView : View {
    var entry: JLPTProvider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    @State private var vocabularies: [Vocabulary] = []
    
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
    
    var systemWidget: some View {
        VStack {
            if let vocabulary = displayVocabulary {
                Text(vocabulary.sound)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .font(Font.system(size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(AttributedString(getAttrributedString(from: vocabulary.word)))
                    .font(Font.system(size: 32))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(vocabulary.meaning)
                    .font(Font.system(size: 18))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
        }.onAppear(perform: {
            loadData()
        })
    }
    
    var accessoryWidget: some View {
        HStack {
            if let vocabulary = displayVocabulary {
                VStack {
                    Text(vocabulary.sound)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                        .font(Font.system(size: 14))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(AttributedString(getAttrributedString(from: vocabulary.word)))
                        .font(Font.system(size: 32))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                Text(vocabulary.meaning)
                    .font(Font.system(size: 18))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
        }.onAppear(perform: {
            loadData()
        })
    }
    
    private var displayVocabulary: Vocabulary? {
        guard !vocabularies.isEmpty else { return nil }
        return vocabularies[(index ?? 0) % vocabularies.count]
    }
    
    private func getAttrributedString(from text: String) -> NSMutableAttributedString {
        let nsAttributedString = NSMutableAttributedString(string: text)
        nsAttributedString.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: text.count))
        return nsAttributedString
    }
    
    private func loadData() {
        let studyPart = entry.configuration.studyPart
        let dict = JSONManager.shared.decode(data: JSONManager.shared.openJSON(path: "jlpt"), type: [String: Vocabulary].self) ?? [:]
        vocabularies = studyPart.idRange.compactMap({ dict[$0] })
    }
}

struct JLPTWidget: Widget {
    let kind: String = "JLPTWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: JLPTConfigurationAppIntent.self, provider: JLPTProvider()) { entry in
            JLPTWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("JLPT 단어")
        .description("JLPT 단어 7965개를 표시합니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

extension JLPTConfigurationAppIntent {
    fileprivate static var jlptBookmark: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptBookmark
        return intent
    }
    fileprivate static var jlptN5: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptN5
        return intent
    }
    fileprivate static var jlptN4: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptN4
        return intent
    }
    fileprivate static var jlptN3: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptN3
        return intent
    }
    fileprivate static var jlptN2: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptN2
        return intent
    }
    fileprivate static var jlptN1: JLPTConfigurationAppIntent {
        let intent = JLPTConfigurationAppIntent()
        intent.studyPart = .jlptN1
        return intent
    }
}

#Preview(as: .systemSmall) {
    JLPTWidget()
} timeline: {
    JLPTSimpleEntry(date: .now, configuration: .jlptN5)
}
