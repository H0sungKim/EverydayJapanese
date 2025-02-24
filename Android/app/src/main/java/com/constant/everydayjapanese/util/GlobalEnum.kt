package com.constant.everydayjapanese.util

import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.extension.LATER
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull

enum class ServerEnum(val shortName: String) {
    production("PR"),
    stage("ST"),
    develop("DEV"),
    home("HOME"),
    office("OFFICE"),
    ;

    companion object {
        val rawToEnum =
            mapOf(
                ServerEnum.production.shortName to ServerEnum.production,
                ServerEnum.stage.shortName to ServerEnum.stage,
                ServerEnum.develop.shortName to ServerEnum.develop,
                ServerEnum.home.shortName to ServerEnum.home,
                ServerEnum.office.shortName to ServerEnum.office,
            )

        fun ofRaw(raw: String): ServerEnum {
            return rawToEnum[raw] ?: ServerEnum.production
        }
    }
}

enum class MimeType(val value: String) {
    image("image/jpeg"),
    video("video/mp4"),
    ;

    fun getShortString(): String {
        return when (this) {
            image -> "IMAGE"
            video -> "VIDEO"
        }
    }

    fun toMediaType(): MediaType? {
        return when (this) {
            image -> "image/*".toMediaTypeOrNull()
            video -> "video/*".toMediaTypeOrNull()
        }
    }

    companion object {
        val rawToEnum =
            mapOf(
                image.value to MimeType.image,
                video.value to MimeType.video,
            )

        fun ofRaw(raw: String): MimeType {
            return rawToEnum[raw] ?: MimeType.image
        }
    }
}


enum class HHFileType {
    imageFromCamera,
    imageFromGallery,
    videoFromGallery,

    // 편집일때
    imageFromUrl,
    videoFromUrl,
    ;

    fun getMimeType(): MimeType {
        return when (this) {
            imageFromCamera, imageFromGallery, imageFromUrl -> MimeType.image
            videoFromGallery, videoFromUrl -> return MimeType.image
        }
    }
}

enum class IndexEnum(val id:Int, val title: String) {
    bookmark(0, "즐겨찾기".LATER()),
    hiragana(1, "히라가나".LATER()),
    katakana(2, "가타카나".LATER()),
    elementary1(3, "소학교 1학년".LATER()),
    elementary2(4, "소학교 2학년".LATER()),
    elementary3(5, "소학교 3학년".LATER()),
    elementary4(6, "소학교 4학년".LATER()),
    elementary5(7, "소학교 5학년".LATER()),
    elementary6(8, "소학교 6학년".LATER()),
    middle(9, "중학교".LATER()),
    n5(10, "N5".LATER()),
    n4(11, "N4".LATER()),
    n3(12, "N3".LATER()),
    n2(13, "N2".LATER()),
    n1(14, "N1".LATER()),
    ;

    companion object {
        val rawToEnum =
            mapOf(
                IndexEnum.bookmark.id to IndexEnum.bookmark,
                IndexEnum.hiragana.id to IndexEnum.hiragana,
                IndexEnum.katakana.id to IndexEnum.katakana,
                IndexEnum.elementary1.id to IndexEnum.elementary1,
                IndexEnum.elementary2.id to IndexEnum.elementary2,
                IndexEnum.elementary3.id to IndexEnum.elementary3,
                IndexEnum.elementary4.id to IndexEnum.elementary4,
                IndexEnum.elementary5.id to IndexEnum.elementary5,
                IndexEnum.elementary6.id to IndexEnum.elementary6,
                IndexEnum.middle.id to IndexEnum.middle,
                IndexEnum.n5.id to IndexEnum.n5,
                IndexEnum.n4.id to IndexEnum.n4,
                IndexEnum.n3.id to IndexEnum.n3,
                IndexEnum.n2.id to IndexEnum.n2,
                IndexEnum.n1.id to IndexEnum.n1,
            )

        fun ofRaw(raw: Int): IndexEnum {
            return rawToEnum[raw] ?: IndexEnum.bookmark
        }
    }

    fun getFileName(): String {
        return when (this) {
            IndexEnum.bookmark, IndexEnum.hiragana, IndexEnum.katakana -> ""
            IndexEnum.elementary1 -> "kanji1.json"
            IndexEnum.elementary2 -> "kanji2.json"
            IndexEnum.elementary3 -> "kanji3.json"
            IndexEnum.elementary4 -> "kanji4.json"
            IndexEnum.elementary5 -> "kanji5.json"
            IndexEnum.elementary6 -> "kanji6.json"
            IndexEnum.middle -> "kanji7.json"
            IndexEnum.n5 -> "n5.json"
            IndexEnum.n4 -> "n4.json"
            IndexEnum.n3 -> "n3.json"
            IndexEnum.n2 -> "n2.json"
            IndexEnum.n1 -> "n1.json"
        }
    }

    fun getSection(): SectionEnum? {
        when(this) {
            IndexEnum.bookmark -> {
                return null
            }
            IndexEnum.hiragana, IndexEnum.katakana -> {
                return SectionEnum.hiraganakatagana
            }
            IndexEnum.elementary1,
            IndexEnum.elementary2,
            IndexEnum.elementary3,
            IndexEnum.elementary4,
            IndexEnum.elementary5,
            IndexEnum.elementary6,
            IndexEnum.middle -> {
                return SectionEnum.kanji
            }
            IndexEnum.n5,
            IndexEnum.n4,
            IndexEnum.n3,
            IndexEnum.n2,
            IndexEnum.n1 -> {
                return SectionEnum.vocabulary
            }
        }
    }

    fun getResourceId() : Int {
        val section = getSection()
        when (section) {
            SectionEnum.hiraganakatagana -> {
                return R.drawable.hiraganakatakana
            }
            SectionEnum.kanji -> {
                return R.drawable.kanji
            }
            SectionEnum.vocabulary -> {
                return R.drawable.jlpt
            }
            else -> {
                return 0
            }
        }
    }

}
enum class SectionEnum(val id:Int, val title: String) {
    hiraganakatagana(0, "히라가나 가타카나 표".LATER()),
    kanji(1, "일본 상용한자".LATER()),
    vocabulary(2, "JLPT 단어장".LATER()),
    ;


    companion object {
        val rawToEnum =
            mapOf(
                SectionEnum.hiraganakatagana.id to SectionEnum.hiraganakatagana,
                SectionEnum.kanji.id to SectionEnum.kanji,
                SectionEnum.vocabulary.id to SectionEnum.vocabulary,

            )

        fun ofRaw(raw: Int): SectionEnum {
            return rawToEnum[raw] ?: SectionEnum.hiraganakatagana
        }
    }
}