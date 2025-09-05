//
//  TatoebaEntity.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation

struct TatoebaEntity: Codable {
    struct ResponseData: Codable {
        struct Transcription: Codable {
            let text: String?
            let html: String?
        }
        
        struct Translation: Codable {
            let id: Int?
            let text: String?
        }
        
        let id: Int?
        let text: String?
        let transcriptions: [Transcription]?
        let translations: [Translation]?
    }
    
    struct Paging: Codable {
        let has_next: Bool?
        let cursor_end: String?
    }
    
    let data: [ResponseData]?
    let paging: Paging?
}
