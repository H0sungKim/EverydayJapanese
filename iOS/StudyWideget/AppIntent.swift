//
//  AppIntent.swift
//  StudyWideget
//
//  Created by 김호성 on 2024.12.02.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an mainichinihongo widget." }

    // An example configurable parameter.
    @Parameter(title: "암기할 부분", default: .kanjiElementary1)
    var studyPart: StudyPartEnum
    
    @Parameter(title: "단어 변경 주기", default: .day)
    var updateInterval: UpdateIntervalEnum
    
}

enum StudyPartEnum: String, AppEnum {
    case kanjiBookmark = "상용한자 즐겨찾기"
    case kanjiElementary1 = "상용한자 소학교 1학년"
    case kanjiElementary2 = "상용한자 소학교 2학년"
    case kanjiElementary3 = "상용한자 소학교 3학년"
    case kanjiElementary4 = "상용한자 소학교 4학년"
    case kanjiElementary5 = "상용한자 소학교 5학년"
    case kanjiElementary6 = "상용한자 소학교 6학년"
    case kanjiMiddle = "상용한자 중학교"
    
    case jlptBookmark = "JLPT 즐겨찾기"
    case jlptN5 = "JLPT N5 단어"
    case jlptN4 = "JLPT N4 단어"
    case jlptN3 = "JLPT N3 단어"
    case jlptN2 = "JLPT N2 단어"
    case jlptN1 = "JLPT N1 단어"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "암기할 부분"
    
    static var caseDisplayRepresentations: [StudyPartEnum : DisplayRepresentation] = [
        .kanjiBookmark: "상용한자 즐겨찾기",
        .kanjiElementary1: "상용한자 소학교 1학년",
        .kanjiElementary2: "상용한자 소학교 2학년",
        .kanjiElementary3: "상용한자 소학교 3학년",
        .kanjiElementary4: "상용한자 소학교 4학년",
        .kanjiElementary5: "상용한자 소학교 5학년",
        .kanjiElementary6: "상용한자 소학교 6학년",
        .kanjiMiddle: "상용한자 중학교",
        
        .jlptBookmark: "JLPT 즐겨찾기",
        .jlptN5: "JLPT N5 단어",
        .jlptN4: "JLPT N4 단어",
        .jlptN3: "JLPT N3 단어",
        .jlptN2: "JLPT N2 단어",
        .jlptN1: "JLPT N1 단어",
    ]
    
    var fileName: String {
        switch self {
        case .kanjiBookmark, .kanjiElementary1, .kanjiElementary2, .kanjiElementary3, .kanjiElementary4, .kanjiElementary5, .kanjiElementary6, .kanjiMiddle:
            return "kanji"
            
        case .jlptBookmark, .jlptN5, .jlptN4, .jlptN3, .jlptN2, .jlptN1:
            return "jlpt"
        }
    }
    
    var idRange: [String] {
        switch self {
        case .kanjiBookmark:
            return Array(GroupedUserDefaultsManager.shared.bookmarkKanji)
        case .kanjiElementary1:
            return (0...79).map({ String($0) })
        case .kanjiElementary2:
            return (80...239).map({ String($0) })
        case .kanjiElementary3:
            return (240...439).map({ String($0) })
        case .kanjiElementary4:
            return (440...641).map({ String($0) })
        case .kanjiElementary5:
            return (642...834).map({ String($0) })
        case .kanjiElementary6:
            return (835...1025).map({ String($0) })
        case .kanjiMiddle:
            return (1026...2135).map({ String($0) })
        case .jlptBookmark:
            return Array(GroupedUserDefaultsManager.shared.bookmarkVoca)
        case .jlptN5:
            return (0...717).map({ String($0) })
        case .jlptN4:
            return (718...1385).map({ String($0) })
        case .jlptN3:
            return (1386...3524).map({ String($0) })
        case .jlptN2:
            return (3525...5269).map({ String($0) })
        case .jlptN1:
            return (5270...7964).map({ String($0) })
        }
    }
}

enum UpdateIntervalEnum: String, AppEnum {
    case day = "하루마다"
    case hour = "한시간마다"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "단어 변경 주기"
    
    static var caseDisplayRepresentations: [UpdateIntervalEnum : DisplayRepresentation] = [
        .day: "하루마다",
        .hour: "한시간마다",
    ]
    
    var calendarEnum: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .hour:
            return .hour
        }
    }
}
