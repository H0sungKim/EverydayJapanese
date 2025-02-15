package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.CursorInfoEntity
import com.constant.everydayjapanese.util.nonNull

class CursorInfoModel {
    var cursor: Int?
    var hasNext: Boolean

    constructor(cursorInfoEntity: CursorInfoEntity?) {
        this.cursor = cursorInfoEntity?.cursor
        this.hasNext = nonNull(cursorInfoEntity?.hasNext)
    }

    constructor(cursor: Int?, hasNext: Boolean) {
        this.cursor = cursor
        this.hasNext = hasNext
    }
}
