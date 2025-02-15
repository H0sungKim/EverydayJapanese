package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.MemberDurationsResponseEntity
import com.constant.everydayjapanese.util.nonNull

class MemberDurationModel {
    val member: MemberModel
    val seconds: Int

    constructor(memberDurationEntity: MemberDurationsResponseEntity.MemberDurationEntity) {
        this.member = MemberModel(memberDurationEntity.member)
        this.seconds = nonNull(memberDurationEntity.seconds)
    }
}
