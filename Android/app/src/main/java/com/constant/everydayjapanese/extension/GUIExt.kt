package com.constant.everydayjapanese.extension

import android.widget.TextView

fun TextView.applyGUI(
    font: Int,
    textColor: Int,
) {
    setTextAppearance(font)
    setTextColor(context.getColor(textColor))
}
