package com.constant.everydayjapanese.scene.main

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityTestBinding
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.model.Vocabulary
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.IndexEnum
import com.constant.everydayjapanese.util.SectionEnum
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.NavigationView

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class TestActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    data class Param (
        var indexEnum: IndexEnum,
        var day:Int = 0,
        var kanjis:ArrayList<Kanji>?,
        var vocabularies:ArrayList<Vocabulary>?
    )
    // companion object
    companion object {
        public val EXTRA_INDEX_ENUM = "EXTRA_INDEX_ENUM"
        public val EXTRA_DAY = "EXTRA_DAY"
        public val EXTRA_KANJIS = "EXTRA_KANJIS"
        public val EXTRA_VOCABULARIES = "EXTRA_VOCABULARIES"
    }
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityTestBinding
    private lateinit var param: Param
    private var index : Int = 0
    private var isVisible = false
    private var testResult = ArrayList<Boolean>()
    private var kanjis:ArrayList<Kanji>? = null
    private var vocabularies:ArrayList<Vocabulary>? = null

    // Override Method or Basic Method
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        initializeVariables()
        initializeViews()
    }

    // Public Method
    // Private Method

    private fun initializeVariables() {
        param = Param(
            IndexEnum.ofRaw(getIntent().getIntExtra(EXTRA_INDEX_ENUM, 0)),
            getIntent().getIntExtra(EXTRA_DAY, 0),
            getIntent().getParcelableArrayListExtra<Kanji>(EXTRA_KANJIS),
            getIntent().getParcelableArrayListExtra<Vocabulary>(EXTRA_VOCABULARIES)
        )

        kanjis = param.kanjis
        vocabularies = param.vocabularies
    }

    private fun initializeViews() {
        binding = ActivityTestBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.apply {
            navigationview.set(nonNull(param.indexEnum.getSection()?.title), nonNull(param.indexEnum.title), param.indexEnum.getResourceId())
            navigationview.setButtonStyle(HHStyle(NavigationView.ButtonId.leftBack))
            navigationview.setOnButtonClickListener(
                object : NavigationView.OnButtonClickListener {
                    override fun onClick(id: Int) {
                        when (id) {
                            NavigationView.ButtonType.back.id -> {
                                finish()
                            }
                            else -> {
                            }
                        }
                    }
                },
            )
            buttonCorrect.setOnClickListener{
                testResult.add(true)
                moveOnToNext()
            }
            buttonWrong.setOnClickListener {
                testResult.add(false)
                moveOnToNext()
            }
            buttonPrevious.setOnClickListener {
                moveOnToPrevious()
            }
            relativelayoutCard.setOnClickListener {
                HHLog.d(TAG, "onClick")
            }
        }
        updateTestField()
    }

    private fun updateTestField() {
        if (index == 0) {
            binding.buttonPrevious.visibility = View.INVISIBLE
        } else {
            binding.buttonPrevious.visibility = View.VISIBLE
        }

        when (param.indexEnum.getSection()) {
            SectionEnum.kanji -> {
                param.kanjis?.let { kanjis ->
                    binding.textviewIndex.text = "$index/${kanjis.size}"
                    val kanji = kanjis.get(index)
                    binding.textviewUpperSub1.text = kanji.jpSound
                    binding.textviewUpperSub2.text = kanji.jpMeaning
                    binding.textviewMain.text = kanji.kanji
                    binding.textviewLowerSub.text = kanji.eumhun
                }
            }
            SectionEnum.vocabulary -> {
                param.vocabularies?.let { vocabularies ->
                    binding.textviewIndex.text = "$index/${vocabularies.size}"
                    val vocabulary = vocabularies.get(index)
                    binding.textviewUpperSub1.text = ""
                    binding.textviewUpperSub2.text = vocabulary.sound
                    binding.textviewMain.text = vocabulary.word
                    binding.textviewLowerSub.text = vocabulary.meaning
                }
            }
            else -> {


            }
        }
    }

    private fun moveOnToNext() {
        index += 1
        if ((param.indexEnum.getSection() == SectionEnum.kanji &&  index == kanjis?.size) ||
                (param.indexEnum.getSection() == SectionEnum.vocabulary &&  index == vocabularies?.size)) {
            // goto test result
            return
        }
        isVisible = false
        updateTestField()
    }

    private fun moveOnToPrevious() {
        if (index == 0) {
            return
        }
        index -= 1
        testResult.removeLast()
        isVisible = false
        updateTestField()
    }
}