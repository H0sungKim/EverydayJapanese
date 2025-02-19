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
}

enum StudyPartEnum: String, AppEnum {
    case kanjiElementary1 = "소학교 1학년"
    case kanjiElementary2 = "소학교 2학년"
    case kanjiElementary3 = "소학교 3학년"
    case kanjiElementary4 = "소학교 4학년"
    case kanjiElementary5 = "소학교 5학년"
    case kanjiElementary6 = "소학교 6학년"
    case kanjiMiddle = "중학교"
    
    case jlptN5 = "N5"
    case jlptN4 = "N4"
    case jlptN3 = "N3"
    case jlptN2 = "N2"
    case jlptN1 = "N1"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "암기할 부분"
    
    static var caseDisplayRepresentations: [StudyPartEnum : DisplayRepresentation] = [
        .kanjiElementary1: "소학교 1학년 상용한자",
        .kanjiElementary2: "소학교 2학년 상용한자",
        .kanjiElementary3: "소학교 3학년 상용한자",
        .kanjiElementary4: "소학교 4학년 상용한자",
        .kanjiElementary5: "소학교 5학년 상용한자",
        .kanjiElementary6: "소학교 6학년 상용한자",
        .kanjiMiddle: "중학교 상용한자",
        
        .jlptN5: "JLPT N5 단어",
        .jlptN4: "JLPT N4 단어",
        .jlptN3: "JLPT N3 단어",
        .jlptN2: "JLPT N2 단어",
        .jlptN1: "JLPT N1 단어",
    ]
    
    var fileName: String {
        switch self {
        case .kanjiElementary1, .kanjiElementary2, .kanjiElementary3, .kanjiElementary4, .kanjiElementary5, .kanjiElementary6, .kanjiMiddle:
            return "kanji"
            
        case .jlptN5, .jlptN4, .jlptN3, .jlptN2, .jlptN1:
            return "jlpt"
        }
    }
    
    var idRange: ClosedRange<Int> {
        switch self {
        case .kanjiElementary1:
            return 0...79
        case .kanjiElementary2:
            return 80...239
        case .kanjiElementary3:
            return 240...439
        case .kanjiElementary4:
            return 440...641
        case .kanjiElementary5:
            return 642...834
        case .kanjiElementary6:
            return 835...1025
        case .kanjiMiddle:
            return 1026...2135
        case .jlptN5:
            return 0...717
        case .jlptN4:
            return 718...1385
        case .jlptN3:
            return 1386...3524
        case .jlptN2:
            return 3525...5269
        case .jlptN1:
            return 5270...7964
        }
    }
}
