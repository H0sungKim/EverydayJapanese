package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toOptionalLocalDateTime
import com.constant.everydayjapanese.network.entity.ApprovalsResponseEntity
import com.constant.everydayjapanese.util.ApprovalType
import com.constant.everydayjapanese.util.AttendanceEnum
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class ApprovalModel {
    val approvalType: ApprovalType
    val id: Int
    var startTime: LocalDateTime? = null
    var endTime: LocalDateTime? = null
    var requestTime: LocalDateTime? = null
    var memberName: String? = null
    var clubName: String? = null
    var attendance: AttendanceEnum? = null

    constructor(approvalEntity: ApprovalsResponseEntity.ApprovalEntity) {
        this.approvalType = ApprovalType.ofRaw(nonNull(approvalEntity.approvalType))
        this.id = nonNull(approvalEntity.id)
        this.startTime = nonNull(approvalEntity.startTime).toOptionalLocalDateTime()
        this.endTime = nonNull(approvalEntity.endTime).toOptionalLocalDateTime()
        this.requestTime = nonNull(approvalEntity.requestTime).toOptionalLocalDateTime()
        this.memberName = approvalEntity.memberName
        this.clubName = approvalEntity.clubName
        this.attendance = AttendanceEnum.ofRaw(nonNull(approvalEntity.attendance))
    }
}
