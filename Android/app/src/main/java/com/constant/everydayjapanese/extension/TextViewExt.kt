package com.constant.everydayjapanese.extension

import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.text.style.StyleSpan
import android.view.View
import android.widget.TextView

fun TextView.setTextOrHide(text: String?) {
    if (text.isNullOrEmpty()) {
        visibility = View.GONE
    } else {
        visibility = View.VISIBLE
        this.text = text
    }
}

fun TextView.asProperty(
    targetStrings: List<String>,
    font: Int,
    color: Int,
) {
    val fullText = this.text.toString()
    val spannableString = SpannableStringBuilder(fullText)

    for (targetString in targetStrings) {
        val startIndex = fullText.indexOf(targetString)
        if (startIndex != -1) {
            val endIndex = startIndex + targetString.length
            spannableString.setSpan(StyleSpan(font), startIndex, endIndex, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            spannableString.setSpan(ForegroundColorSpan(color), startIndex, endIndex, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        }
    }

    this.text = spannableString
}
