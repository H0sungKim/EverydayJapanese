package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toLocalDateTime
import com.constant.everydayjapanese.network.entity.DailyDurationEntity
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class DailyDurationModel {
    val date: LocalDateTime
    val seconds: Int

    constructor(dailyDurationEntity: DailyDurationEntity) {
        this.date = nonNull(dailyDurationEntity.date).toLocalDateTime()
        this.seconds = nonNull(dailyDurationEntity.seconds)
    }
}
