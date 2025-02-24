package com.constant.everydayjapanese.util


// ----------------------------------------------------
// Public Method
fun nonNull(text: String?): String {
    return text ?: ""
}

fun nonNull(obj: Object?): Object {
    return obj ?: Object()
}

fun nonNull(i: Int?): Int {
    return i ?: 0
}

fun nonNull(i: Long?): Long {
    return i ?: 0
}

fun nonNull(b: Boolean?): Boolean {
    return b ?: false
}

fun nonNull(d: Double?): Double {
    return d ?: 0.0
}

fun nonNull(a: ByteArray?): ByteArray {
    return a ?: ByteArray(0)
}

fun nonNull(a: Array<Any>?): Array<Any> {
    return a ?: arrayOf()
}

fun nonNull(a: Array<String>?): Array<String> {
    return a ?: arrayOf()
}


@JvmName("callFromString")
fun nonNull(a: ArrayList<String>?): ArrayList<String> {
    return a ?: ArrayList<String>()
}

