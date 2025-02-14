package com.constant.everydayjapanese.network.entity

import com.google.gson.annotations.SerializedName

class SentenceResponseEntity {
    inner class ResponseDataEntity {
        @SerializedName("id")
        val id: Int? = null

        @SerializedName("text")
        val text: String? = null

        @SerializedName("transcriptions")
        val transcriptions: Array<TranscriptionEntity>? = null
    }

    inner class TranscriptionEntity {
        @SerializedName("text")
        val text: String? = null

        @SerializedName("html")
        val html: String? = null
    }

    @SerializedName("data")
    val data: Array<ResponseDataEntity>? = null
}
