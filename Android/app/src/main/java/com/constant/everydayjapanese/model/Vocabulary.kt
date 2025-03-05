package com.constant.everydayjapanese.model

import android.os.Parcelable
import com.google.gson.reflect.TypeToken
import kotlinx.parcelize.Parcelize

@Parcelize
class Vocabulary(
    val word: String,
    val sound: String,
    val meaning: String
) : Parcelable {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is Vocabulary) return false
        return (this.word == other.word &&
                this.sound == other.sound &&
                this.meaning == other.meaning)
    }

    override fun hashCode(): Int {
        var result = word.hashCode()
        result = 31 * result + sound.hashCode()
        result = 31 * result + meaning.hashCode()
        return result
    }
}

class VocabularyListType : TypeToken<List<Vocabulary>>() {}