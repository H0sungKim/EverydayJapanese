package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.SentenceResponseEntity
import com.constant.everydayjapanese.util.nonNull

class SentenceModel {
    var id: Int
    var text: String
    var rubyText: String
    var html: String

    constructor(sentenceResponseEntity: SentenceResponseEntity) {
        id = nonNull(sentenceResponseEntity.data?.get(0)?.id)
        text = nonNull(sentenceResponseEntity.data?.get(0)?.text)
        rubyText = nonNull(sentenceResponseEntity.data?.get(0)?.transcriptions?.get(0)?.text)
        html = nonNull(sentenceResponseEntity.data?.get(0)?.transcriptions?.get(0)?.html)
    }

    override fun toString(): String {
        return "SentenceModel(id=$id, text='$text', rubyText='$rubyText', html='$html')"
    }
}
