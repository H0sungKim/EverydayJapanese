package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.MemberAttendancesResponseEntity

class MemberAttendancesModel {
    val member: MemberModel
    val attendances: ArrayList<AttendanceModel>

    constructor(memberAttendancesResponseEntity: MemberAttendancesResponseEntity) {
        this.member = MemberModel(memberAttendancesResponseEntity.responseData?.member)
        this.attendances = ArrayList<AttendanceModel>()
        memberAttendancesResponseEntity.responseData?.attendances?.let {
            it.forEach { attendanceEntity ->
                attendances.add(AttendanceModel(attendanceEntity))
            }
        }
    }

    constructor() {
        this.member = MemberModel()
        this.attendances = ArrayList<AttendanceModel>()
    }
}
