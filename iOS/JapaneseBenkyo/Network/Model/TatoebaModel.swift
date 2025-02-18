//
//  TatoebaModel.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation

struct TatoebaModel: Codable {
    let id: Int
    let text: String
    let rubyText: String
    let html: String
    
    let korText: String
    
    let hasNext: Bool
    let cursor_end: String
    
    init(tatoebaEntity: TatoebaEntity) {
        self.id = tatoebaEntity.data?.first?.id ?? 0
        self.text = tatoebaEntity.data?.first?.text ?? "예문이 없습니다."
        self.rubyText = tatoebaEntity.data?.first?.transcriptions?.first?.text ?? "예문이 없습니다."
        self.html = tatoebaEntity.data?.first?.transcriptions?.first?.html ?? "예문이 없습니다."
        self.korText = tatoebaEntity.data?.first?.translations?.compactMap({
            $0.isEmpty ? nil : $0
        }).first?.first?.text ?? ""
        self.hasNext = tatoebaEntity.paging?.has_next ?? false
        self.cursor_end = tatoebaEntity.paging?.cursor_end ?? ""
    }
    
    init() {
        self.id = 0
        self.text = "예문이 없습니다."
        self.rubyText = "예문이 없습니다."
        self.html = "예문이 없습니다."
        self.korText = ""
        self.hasNext = false
        self.cursor_end = ""
    }
}
