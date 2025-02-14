package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toLocalDateTime
import com.constant.everydayjapanese.network.entity.AnnouncesResponseEntity
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class AnnounceModel {
    var id: Int
    var url: String
    var createdDate: LocalDateTime

    constructor(announceEntity: AnnouncesResponseEntity.AnnounceEntity) {
        this.id = nonNull(announceEntity.id)
        this.url = nonNull(announceEntity.url)
        this.createdDate = nonNull(announceEntity.createdDate).toLocalDateTime()
    }
}
