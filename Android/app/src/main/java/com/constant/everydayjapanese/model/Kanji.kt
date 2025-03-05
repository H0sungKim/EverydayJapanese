package com.constant.everydayjapanese.model

import android.os.Parcelable
import com.google.gson.reflect.TypeToken
import kotlinx.parcelize.Parcelize

@Parcelize
class Kanji(
    val kanji: String,
    val hanja: String,
    val eumhun: String,
    val jpSound: String,
    val jpMeaning: String,
    val examples: List<Vocabulary> = emptyList(),
) : Parcelable {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is Kanji) return false
        return (
            this.kanji == other.kanji &&
                this.hanja == other.hanja &&
                this.eumhun == other.eumhun &&
                this.jpSound == other.jpSound &&
                this.jpMeaning == other.jpMeaning &&
                this.examples == other.examples
        )
    }

    override fun hashCode(): Int {
        var result = kanji.hashCode()
        result = 31 * result + hanja.hashCode()
        result = 31 * result + eumhun.hashCode()
        result = 31 * result + jpSound.hashCode()
        result = 31 * result + jpMeaning.hashCode()
        result = 31 * result + examples.hashCode()
        return result
    }

    override fun toString(): String {
        return "Kanji(kanji='$kanji', hanja='$hanja', eumhun='$eumhun', jpSound='$jpSound', jpMeaning='$jpMeaning', examples=$examples)"
    }
}

class KanjiListType : TypeToken<List<Kanji>>()
