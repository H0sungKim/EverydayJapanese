package com.constant.everydayjapanese.singleton

import android.R
import android.content.Context
import android.graphics.Color
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import android.text.style.SuperscriptSpan
import android.text.style.TextAppearanceSpan
import com.constant.everydayjapanese.util.nonNull
import io.reactivex.rxjava3.subjects.ReplaySubject

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class RubyAnnotationManager {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: RubyAnnotationManager

        fun getInstance(): RubyAnnotationManager {
            synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = RubyAnnotationManager()
                }
                return instance
            }
        }
    }
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    // Override Method or Basic Method
    constructor() {
    }

    // Public Method
    fun getRubyAnnotationString(context: Context, html: String, sentence: String): SpannableStringBuilder {
        val spannableString = SpannableStringBuilder(sentence)

        // 기본 스타일 적용
        spannableString.setSpan(
            TextAppearanceSpan(context, R.style.TextAppearance_Medium),
            0, spannableString.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)

        val regexExtractRuby = "<ruby>.*?</ruby>".toRegex()
        val rubyMatches = regexExtractRuby.findAll(html)

        var searchStartIndex = 0
        for (rubyMatch in rubyMatches) {
            val rubyText = rubyMatch.value
            val regexExtractFurigana = "<ruby>(.*?)<rp>（</rp><rt>(.*?)</rt><rp>）</rp></ruby>".toRegex()
            val matchResult = regexExtractFurigana.find(rubyText)

            if (matchResult != null) {
                val (originalText, furiganaText) = matchResult.destructured

                // 원문 위치 찾기
                val originalIndex = sentence.indexOf(originalText, searchStartIndex)
                if (originalIndex == -1) continue

                val originalEnd = originalIndex + originalText.length
                searchStartIndex = originalEnd

                // 발음 (furigana) 추가 - Superscript + 작은 글씨 적용
                spannableString.setSpan(SuperscriptSpan(), originalIndex, originalEnd, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                spannableString.setSpan(RelativeSizeSpan(0.5f), originalIndex, originalEnd, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                spannableString.setSpan(ForegroundColorSpan(Color.GRAY), originalIndex, originalEnd, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            }
        }
        return spannableString
    }
    // Private Method

}