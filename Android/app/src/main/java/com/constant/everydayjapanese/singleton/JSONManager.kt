package com.constant.everydayjapanese.singleton

import android.content.Context
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.model.KanjiListType
import com.constant.everydayjapanese.model.ProcessHashMapType
import com.constant.everydayjapanese.model.Vocabulary
import com.constant.everydayjapanese.model.VocabularyListType
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.nonNull
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import org.json.JSONArray
import org.json.JSONObject

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface
class JSONManager {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: JSONManager

        fun getInstance(): JSONManager {
            synchronized(this) {
                if (!Companion::instance.isInitialized) {
                    instance = JSONManager()
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
    private val gson = Gson()

    // Override Method or Basic Method
    private constructor() {
    }

    // Public Method
    // JSON 파일을 읽고 파싱하여 HashMap으로 변환
    fun parseJsonToHashMap(
        context: Context,
        fileName: String,
    ): HashMap<String, String> {
        val hashMap = HashMap<String, String>()

        try {
            // JSON 파일 읽기
            val jsonString = loadJsonFromAsset(context, fileName)

            // JSON 파싱
            val jsonObject = JSONObject(jsonString)
            val keys = jsonObject.keys()

            while (keys.hasNext()) {
                val key = keys.next()
                val value = jsonObject.getString(key)
                hashMap[key] = value
            }
        } catch (e: Exception) {
            HHLog.e(TAG, "parseJsonToHashMap() Error : ${e.message}")
        }

        return hashMap
    }

    fun parseJsonArrayToList(
        context: Context,
        fileName: String,
    ): List<HashMap<String, String>> {
        val list = mutableListOf<HashMap<String, String>>()

        try {
            val jsonString = loadJsonFromAsset(context, fileName)

            if (jsonString.trim().startsWith("[")) {
                val jsonArray = JSONArray(jsonString)

                for (i in 0 until jsonArray.length()) {
                    val jsonObject = jsonArray.getJSONObject(i)
                    val map = HashMap<String, String>()
                    val keys = jsonObject.keys()

                    while (keys.hasNext()) {
                        val key = keys.next()
                        val value = jsonObject.getString(key)
                        map[key] = value
                    }

                    list.add(map)
                }
            }
        } catch (e: Exception) {
            HHLog.e(TAG, "parseJsonArrayToList() Error : ${e.message}")
            // e.printStackTrace()
        }

        return list
    }

    // assets에서 JSON 파일을 읽어 문자열로 반환
    fun loadJsonFromAsset(
        context: Context,
        fileName: String,
    ): String {
        return try {
            val inputStream = context.assets.open(fileName)
            val size = inputStream.available()
            val buffer = ByteArray(size)
            inputStream.read(buffer)
            inputStream.close()

            String(buffer, Charsets.UTF_8)
        } catch (e: Exception) {
            HHLog.e(TAG, "loadJsonFromAsset() Error : ${e.message}")
            ""
        }
    }

    // --------------------------------------------------------
    fun encodeProcessJSON(process: HashMap<String, HashMap<String, Boolean>>): String {
        return try {
            gson.toJson(process)
        } catch (e: Exception) {
            HHLog.e(TAG, "encodeProcessJSON() Error : ${e.message}")
            ""
        }
    }

    fun decodeProcessJSON(jsonData: ByteArray): HashMap<String, HashMap<String, Boolean>> {
        return try {
            val jsonString = String(jsonData)
            HHLog.d(TAG, "1")
            val type = ProcessHashMapType().type
            HHLog.d(TAG, "2")
            gson.fromJson<HashMap<String, HashMap<String, Boolean>>>(jsonString, type)
        } catch (e: Exception) {
            HHLog.e(TAG, "decodeProcessJSON() Error : ${e.message}")
            HashMap<String, HashMap<String, Boolean>>()
        }
    }

    fun encodeVocabularyJSON(vocabularies: Set<Vocabulary>): String {
        return try {
            gson.toJson(vocabularies)
        } catch (e: Exception) {
            HHLog.e(TAG, "encodeVocabularyJSON() Error : ${e.message}")
            ""
        }
    }

    fun decodeJSONtoVocabularyArray(jsonData: String): List<Vocabulary> {
        return try {
            val type = VocabularyListType().type
            gson.fromJson(jsonData, type)
        } catch (e: Exception) {
            HHLog.e(TAG, "decodeJSONtoVocabularyArray() Error : ${e.message}")
            emptyList()
        }
    }

    fun decodeJSONtoVocabularySet(jsonData: String): HashSet<Vocabulary> {
        return try {
            val type = object : TypeToken<HashSet<Vocabulary>>() {}.type
            gson.fromJson(jsonData, type) ?: HashSet()
        } catch (e: Exception) {
            HHLog.e(TAG, "decodeJSONtoVocabularySet() Error : ${e.message}")
            HashSet()
        }
    }

    fun encodeKanjiJSON(kanjis: Set<Kanji>): String {
        return try {
            gson.toJson(kanjis)
        } catch (e: Exception) {
            HHLog.e(TAG, "encodeKanjiJSON() Error : ${e.message}")
            ""
        }
    }

    fun decodeJSONtoKanjiArray(jsonData: String): List<Kanji> {
        return try {
            val type = KanjiListType().type
            gson.fromJson<List<Kanji>>(jsonData, type)
        } catch (e: Exception) {
            HHLog.e(TAG, "decodeJSONtoKanjiArray() Error : ${e.message}")
            emptyList()
        }
    }

    fun decodeJSONtoKanjiSet(jsonData: String): HashSet<Kanji> {
        return try {
            val type = object : TypeToken<HashSet<Kanji>>() {}.type
            gson.fromJson(jsonData, type) ?: HashSet()
        } catch (e: Exception) {
            HHLog.e(TAG, "decodeJSONtoKanjiSet() Error : ${e.message}")
            HashSet()
        }
    }

    fun convertStringToByteArray(jsonString: String): ByteArray? {
        return jsonString.toByteArray(Charsets.UTF_8)
    }

    // Private Method
}
