package com.constant.everydayjapanese.network

import android.content.Context
import com.constant.everydayjapanese.extension.FormatType
import com.constant.everydayjapanese.extension.getDateString
import com.constant.everydayjapanese.model.DataModel
import com.constant.everydayjapanese.network.model.*
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.MimeType
import com.constant.everydayjapanese.util.PositionEnum
import com.constant.everydayjapanese.util.WithdrawalReason
import com.constant.everydayjapanese.util.nonNull
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonPrimitive
import io.reactivex.rxjava3.core.Observable
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.ResponseBody
import java.time.LocalDateTime

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class TatoebaRepository {
    // Public Inner Class, Struct, Enum, Interface

    class Style {
        companion object {
            val none = 0
            val loadingSpinner = 1 shl 0
            val showErrorDialog = 1 shl 1
        }
    }

    // companion object
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)
    // Public Variable

    // ----------------------------------------------------
    // Private Variable
    private var style: HHStyle

    // ----------------------------------------------------
    // Override Method or Basic Method
    constructor(style: HHStyle) {
        this.style = style
    }

    // ----------------------------------------------------
    // Public Method
    // ----- 기본 -------

    fun getSentence(context: Context, q: String): Observable<SentenceModel> {
        val lang = "jpn"
        val limit = 1
        return TatoebaRestAPI(context, style).getSentence(lang, q, limit)
            .map { SentenceModel(it) }
    }

    // Private Method
}
