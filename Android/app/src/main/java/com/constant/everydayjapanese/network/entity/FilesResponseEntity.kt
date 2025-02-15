package com.constant.everydayjapanese.network.entity

import com.google.gson.annotations.SerializedName

class FilesResponseEntity {
    @SerializedName("responseCode")
    val responseCode: Int? = null

    @SerializedName("responseMessage")
    val responseMessage: String? = null

    @SerializedName("responseData")
    val responseData: Array<FileEntity>? = null

    @SerializedName("cursorInfo")
    val cursorInfo: CursorInfoEntity? = null
}
