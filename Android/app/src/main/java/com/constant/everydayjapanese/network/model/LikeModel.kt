package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.LikeResponseEntity
import com.constant.everydayjapanese.util.nonNull

class LikeModel {
    val likeCount: Int
    val likeOn: Boolean

    constructor(likeResponseEntity: LikeResponseEntity) {
        this.likeCount = nonNull(likeResponseEntity.responseData?.likeCount)
        this.likeOn = nonNull(likeResponseEntity.responseData?.likeOn)
    }
}
