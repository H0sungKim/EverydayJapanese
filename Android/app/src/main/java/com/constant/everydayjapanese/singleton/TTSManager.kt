package com.constant.everydayjapanese.singleton

import android.speech.tts.TextToSpeech
import com.constant.everydayjapanese.basic.EverydayJapaneseApplication
import com.constant.everydayjapanese.util.nonNull
import java.util.Locale

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class TTSManager : TextToSpeech.OnInitListener {
    // Public Inner Class, Struct, Enum, Interface

    // ----------------------------------------------------
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: TTSManager

        fun getInstance(): TTSManager {
            synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = TTSManager()
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
    private lateinit var tts: TextToSpeech
    private var isInitialized = false

    // Override Method or Basic Method
    constructor() {
        tts = TextToSpeech(EverydayJapaneseApplication.context, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            tts?.language = Locale.JAPANESE
            tts?.setSpeechRate(1.0f) // 속도 조절 (기본값: 1.0)
            tts?.setPitch(1.0f) // 톤 조절 (기본값: 1.0)
            isInitialized = true
        }
    }
    // Public Method

    fun speak(text: String) {
        if (isInitialized) {
            tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
        } else {
            println("TTS 초기화 안 됨")
        }
    }

    fun stop() {
        tts?.stop()
    }

    // Private Method
}
