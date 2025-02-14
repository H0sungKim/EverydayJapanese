package com.constant.everydayjapanese.network.entity

import com.google.gson.annotations.SerializedName

class VoidResponseEntity {
    @SerializedName("responseCode")
    val responseCode: Int? = null

    @SerializedName("responseMessage")
    val responseMessage: String? = null
}
