package com.constant.everydayjapanese.util

import com.constant.everydayjapanese.basic.EverydayJapaneseApplication

fun STR(resId: Int): String {
    return EverydayJapaneseApplication.context.getString(resId)
}

fun LATER(strText: String): String {
    return strText
}
