package com.constant.everydayjapanese.singleton


// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class HiraganaKatakanaManager {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: HiraganaKatakanaManager

        fun getInstance(): HiraganaKatakanaManager {
            synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = HiraganaKatakanaManager()
                }
                return instance
            }
        }
    }

    // Public Constant
    // Private Constant
    // Public Variable
    val hiraganaKatakana: List<String> = listOf(
        "あ", "い", "う", "え", "お",
        "か", "き", "く", "け", "こ",
        "さ", "し", "す", "せ", "そ",
        "た", "ち", "つ", "て", "と",
        "な", "に", "ぬ", "ね", "の",
        "は", "ひ", "ふ", "へ", "ほ",
        "ま", "み", "む", "め", "も",
        "や",      "ゆ",       "よ",
        "ら", "り", "る", "れ", "ろ",
        "わ",                 "を",
        "ん",
        "ア", "イ", "ウ", "エ", "オ",
        "カ", "キ", "ク", "ケ", "コ",
        "サ", "シ", "ス", "セ", "ソ",
        "タ", "チ", "ツ", "テ", "ト",
        "ナ", "ニ", "ヌ", "ネ", "ノ",
        "ハ", "ヒ", "フ", "ヘ", "ホ",
        "マ", "ミ", "ム", "メ", "モ",
        "ヤ",      "ユ",       "ヨ",
        "ラ", "リ", "ル", "レ", "ロ",
        "ワ",                 "ヲ",
        "ン"
    )

    val hiragana: String = "あいうえおかきくけこさしすせそたちってとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
    val katakana: String = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフへホマミムメモヤユヨラリルレロワヲン"

    val hiraganaTuple: List<Pair<String, String>> = listOf(
        "あ" to "아 a", "い" to "이 i", "う" to "우 u", "え" to "에 e", "お" to "오 o",
        "か" to "카 ka", "き" to "키 ki", "く" to "쿠 ku", "け" to "케 ke", "こ" to "코 ko",
        "さ" to "사 sa", "し" to "시 si", "す" to "스 su", "せ" to "세 se", "そ" to "소 so",
        "た" to "타 ta", "ち" to "치 chi", "つ" to "츠 tsu", "て" to "테 te", "と" to "토 to",
        "な" to "나 na", "に" to "니 ni", "ぬ" to "누 nu", "ね" to "네 ne", "の" to "노 no",
        "は" to "하 ha", "ひ" to "히 hi", "ふ" to "후 hu", "へ" to "헤 he", "ほ" to "호 ho",
        "ま" to "마 ma", "み" to "미 mi", "む" to "무 mu", "め" to "메 me", "も" to "모 mo",
        "や" to "야 ya", "ゆ" to "유 yu", "よ" to "요 yo",
        "ら" to "라 ra", "り" to "리 ri", "る" to "루 ru", "れ" to "레 re", "ろ" to "로 ro",
        "わ" to "와 wa", "を" to "오 wo",
        "ん" to "응 n"
    )

    val katakanaTuple: List<Pair<String, String>> = listOf(
        "ア" to "아 a", "イ" to "이 i", "ウ" to "우 u", "エ" to "에 e", "オ" to "오 o",
        "カ" to "카 ka", "キ" to "키 ki", "ク" to "쿠 ku", "ケ" to "케 ke", "コ" to "코 ko",
        "サ" to "사 sa", "シ" to "시 si", "ス" to "스 su", "セ" to "세 se", "ソ" to "소 so",
        "タ" to "타 ta", "チ" to "치 chi", "ツ" to "츠 tsu", "テ" to "테 te", "ト" to "토 to",
        "ナ" to "나 na", "ニ" to "니 ni", "ヌ" to "누 nu", "ネ" to "네 ne", "ノ" to "노 no",
        "ハ" to "하 ha", "ヒ" to "히 hi", "フ" to "후 hu", "ヘ" to "헤 he", "ホ" to "호 ho",
        "マ" to "마 ma", "ミ" to "미 mi", "ム" to "무 mu", "メ" to "메 me", "モ" to "모 mo",
        "ヤ" to "야 ya", "ユ" to "유 yu", "ヨ" to "요 yo",
        "ラ" to "라 ra", "リ" to "리 ri", "ル" to "루 ru", "レ" to "레 re", "ロ" to "로 ro",
        "ワ" to "와 wa", "ヲ" to "오 wo",
        "ン" to "응 n"
    )
    // Private Variable
    // Override Method or Basic Method
    constructor() {
    }
    // Public Method
    // Private Method
}