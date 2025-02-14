package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toLocalDateTime
import com.constant.everydayjapanese.network.entity.AttendanceEntity
import com.constant.everydayjapanese.util.AttendanceEnum
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class AttendanceModel {
    val startTime: LocalDateTime
    val endTime: LocalDateTime
    val attendance: AttendanceEnum

    constructor(attendanceEntity: AttendanceEntity) {
        this.startTime = nonNull(attendanceEntity.startTime).toLocalDateTime()
        this.endTime = nonNull(attendanceEntity.endTime).toLocalDateTime()
        this.attendance = AttendanceEnum.ofRaw(nonNull(attendanceEntity.attendance)) ?: AttendanceEnum.checkIn
    }
}
