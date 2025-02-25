package com.constant.everydayjapanese.scene.main

import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityStudyBinding
import com.constant.everydayjapanese.extension.applyGUI
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.model.Vocabulary
import com.constant.everydayjapanese.singleton.GlobalVariable
import com.constant.everydayjapanese.singleton.JSONManager
import com.constant.everydayjapanese.singleton.Pref
import com.constant.everydayjapanese.singleton.PrefManager
import com.constant.everydayjapanese.singleton.TTSManager
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.IndexEnum
import com.constant.everydayjapanese.util.SectionEnum
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.ColorDivider
import com.constant.everydayjapanese.view.NavigationView
import io.reactivex.rxjava3.disposables.CompositeDisposable

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class StudyActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    interface OnSelectItemListener {
        fun onSelectItem(position: Int)
    }

    data class Param (
        var indexEnum:IndexEnum,
        var day:Int = 0,
        var kanjisDayDistributed:List<Kanji>?,
        var vocabulariesDayDistributed:List<Vocabulary>?
    )

    data class KanjiForCell(
        var kanji: Kanji,
        var isVisible: Boolean = false,
        var isVisibleHanja: Boolean = false,
        var isBookmark: Boolean = false,
        var isExpanded: Boolean = false
    )
    data class VocabularyForCell(
        var vocabulary: Vocabulary,
        var isVisible: Boolean = false,
        var isBookmark: Boolean = false,
        var isExpanded: Boolean = false,
        var exampleText: String? = null
    )
    // companion object
    companion object {
        public val EXTRA_INDEX_ENUM = "EXTRA_INDEX_ENUM"
        public val EXTRA_DAY = "EXTRA_DAY"
        public val EXTRA_KANJIS_DAY_DISTRIBUTED = "EXTRA_KANJIS_DAY_DISTRIBUTED"
        public val EXTRA_VOCABULARIES_DAY_DISTRIBUTED = "EXTRA_VOCABULARIES_DAY_DISTRIBUTED"
    }
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityStudyBinding
    private lateinit var kanjiAdapter: KanjiAdapter
    private lateinit var vocabularyAdapter: VocabularyAdapter

    // Param
    private lateinit var param: Param
    private var kanjisForCell: List<KanjiForCell>? = null
    private var vocabulariesForCell: List<VocabularyForCell>? = null
    private var kanjiBookmarks: HashSet<Kanji> = HashSet<Kanji>()
    private var vocabularyBookmarks: HashSet<Vocabulary> = HashSet<Vocabulary>()

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
            getIntent().getParcelableArrayListExtra<Kanji>(EXTRA_KANJIS_DAY_DISTRIBUTED),
            getIntent().getParcelableArrayListExtra<Vocabulary>(EXTRA_VOCABULARIES_DAY_DISTRIBUTED)
        )
        kanjisForCell = param.kanjisDayDistributed?.map {
            return@map KanjiForCell(it)
        }

        PrefManager.getInstance().getStringValue(
            Pref.kanjiBookmark.name)?.let {
            kanjiBookmarks = JSONManager.getInstance().decodeJSONtoKanjiSet(it)
        }

        kanjisForCell?.forEach { kanjiForCell ->
            kanjiForCell.isBookmark = kanjiBookmarks.contains(kanjiForCell.kanji)
        }

        vocabulariesForCell = param.vocabulariesDayDistributed?.map {
            return@map VocabularyForCell(it)
        }

        PrefManager.getInstance().getStringValue(
            Pref.vocabularyBookmark.name)?.let {
            vocabularyBookmarks = JSONManager.getInstance().decodeJSONtoVocabularySet(it)
        }

        vocabulariesForCell?.forEach { vocabularyForCell ->
            vocabularyForCell.isBookmark = vocabularyBookmarks.contains(vocabularyForCell.vocabulary)
        }

        // 초기화 때문에 필요
        TTSManager.getInstance()
    }

    private fun initializeViews() {
        binding = ActivityStudyBinding.inflate(layoutInflater)
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

            buttonTest.setOnClickListener {
                val intent = Intent(this@StudyActivity, TestActivity::class.java)
                intent.putExtra(TestActivity.EXTRA_INDEX_ENUM, param.indexEnum.id)
                intent.putExtra(TestActivity.EXTRA_DAY, param.day)
                when(param.indexEnum.getSection()) {
                    SectionEnum.kanji -> {
                        param.kanjisDayDistributed?.let { kanjisDayDistributed ->
                            intent.putExtra(TestActivity.EXTRA_KANJIS, ArrayList(kanjisDayDistributed))
                        }
                    }
                    SectionEnum.vocabulary -> {
                        param.vocabulariesDayDistributed?.let { vocabulariesDayDistributed ->
                            intent.putExtra(TestActivity.EXTRA_VOCABULARIES, ArrayList(vocabulariesDayDistributed))
                        }
                    }
                    else -> {
                        HHLog.d(TAG, "do nothing!")
                    }
                }
                startActivity(intent)
            }

            if (param.indexEnum.getSection() == SectionEnum.kanji || 0 < nonNull(kanjisForCell?.size)) {
                kanjisForCell?.let {  kanjisForCell ->
                    kanjiAdapter = KanjiAdapter(this@StudyActivity, kanjisForCell, kanjiBookmarks)
                    kanjiAdapter.setOnSelectItemListener(
                        object : OnSelectItemListener {
                            override fun onSelectItem(position: Int) {
                                kanjisForCell.get(position).isVisible = !kanjisForCell.get(position).isVisible
                                kanjiAdapter.notifyItemChanged(position)
                            }
                        })
                    recyclerview.adapter = kanjiAdapter
                }
            } else if (param.indexEnum.getSection() == SectionEnum.vocabulary || 0 < nonNull(vocabulariesForCell?.size)){ // vocabulary
                vocabulariesForCell?.let { vocabulariesForCell ->
                    vocabularyAdapter = VocabularyAdapter(this@StudyActivity, vocabulariesForCell, vocabularyBookmarks)
                    vocabularyAdapter.setOnSelectItemListener(
                        object : OnSelectItemListener {
                            override fun onSelectItem(position: Int) {
                                vocabulariesForCell.get(position)?.isVisible = !vocabulariesForCell.get(position).isVisible
                                vocabularyAdapter.notifyItemChanged(position)
                            }
                        })
                    recyclerview.adapter = vocabularyAdapter
                }
            }
            recyclerview.addItemDecoration(
                ColorDivider(1f, 10f, this@StudyActivity.getColor(R.color.bg4)) {
                    true
                },
            )
        }
    }
}