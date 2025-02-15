package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toLocalDateTime
import com.constant.everydayjapanese.network.entity.MemberAttendanceEntity
import com.constant.everydayjapanese.util.AttendanceEnum
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class MemberAttendanceModel {
    val member: MemberModel
    val startTime: LocalDateTime
    val endTime: LocalDateTime
    val attendance: AttendanceEnum

    constructor(memberAttendanceEntity: MemberAttendanceEntity) {
        this.member = MemberModel(memberAttendanceEntity.member)
        this.startTime = nonNull(memberAttendanceEntity.startTime).toLocalDateTime()
        this.endTime = nonNull(memberAttendanceEntity.endTime).toLocalDateTime()
        this.attendance = AttendanceEnum.ofRaw(nonNull(memberAttendanceEntity.attendance)) ?: AttendanceEnum.checkIn
    }
}
