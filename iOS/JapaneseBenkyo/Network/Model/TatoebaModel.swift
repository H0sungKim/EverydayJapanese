//
//  TatoebaModel.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation

enum TransEnum: String {
    case kor
    case eng
}

struct TatoebaModel {
    let id: Int
    let text: String
    let rubyText: String
    let html: String
    
    let transEnum: TransEnum
    let transText: String
    
    let hasNext: Bool
    let cursor_end: String
    
    init(tatoebaEntity: TatoebaEntity, trans: TransEnum) {
        self.id = tatoebaEntity.data?.first?.id ?? 0
        self.text = tatoebaEntity.data?.first?.text ?? "예문이 없습니다."
        self.rubyText = tatoebaEntity.data?.first?.transcriptions?.first?.text ?? "예문이 없습니다."
        self.html = tatoebaEntity.data?.first?.transcriptions?.first?.html ?? "예문이 없습니다."
        self.transEnum = trans
        self.transText = tatoebaEntity.data?.first?.translations?.first?.text ?? ""
        self.hasNext = tatoebaEntity.paging?.has_next ?? false
        self.cursor_end = tatoebaEntity.paging?.cursor_end ?? ""
    }
}
