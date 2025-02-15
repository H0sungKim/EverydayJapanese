package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.MemberDailyDurationsResponseEntity

class MemberDailyDurationsModel {
    val member: MemberModel
    val dailyDurations: ArrayList<DailyDurationModel>

    constructor(memberDailyDurationEntity: MemberDailyDurationsResponseEntity.MemberDailyDurationEntity) {
        this.member = MemberModel(memberDailyDurationEntity.member)
        this.dailyDurations = ArrayList<DailyDurationModel>()
        memberDailyDurationEntity.dailyDurations?.let {
            it.forEach { dailyDurationEntity ->
                dailyDurations.add(DailyDurationModel(dailyDurationEntity))
            }
        }
    }
}
