package com.constant.everydayjapanese.scene.main

import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.RecyclerView
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityTestResultBinding
import com.constant.everydayjapanese.extension.applyGUI
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.model.Vocabulary
import com.constant.everydayjapanese.scene.main.StudyActivity.KanjiForCell
import com.constant.everydayjapanese.scene.main.StudyActivity.OnSelectItemListener
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

class TestResultActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface

    data class Param (
        var indexEnum: IndexEnum,
        var day:Int = 0,
        var allCount:Int = 0,
        var kanjis:List<Kanji>?,
        var vocabularies:List<Vocabulary>?
    )


    // companion object
    companion object {
        public val EXTRA_INDEX_ENUM = "EXTRA_INDEX_ENUM"
        public val EXTRA_DAY = "EXTRA_DAY"
        public val EXTRA_ALL_COUNT = "EXTRA_ALL_COUNT"
        public val EXTRA_KANJIS = "EXTRA_KANJIS"
        public val EXTRA_VOCABULARIES = "EXTRA_VOCABULARIES"
    }

    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityTestResultBinding
    private lateinit var kanjiAdapter: KanjiAdapter
    private lateinit var vocabularyAdapter: VocabularyAdapter

    private lateinit var param: Param
    private var kanjisForCell: List<StudyActivity.KanjiForCell>? = null
    private var vocabulariesForCell: List<StudyActivity.VocabularyForCell>? = null
    private val compositeDisposable = CompositeDisposable()
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
            getIntent().getIntExtra(EXTRA_ALL_COUNT, 0),
            getIntent().getParcelableArrayListExtra<Kanji>(EXTRA_KANJIS),
            getIntent().getParcelableArrayListExtra<Vocabulary>(EXTRA_VOCABULARIES)
        )
        kanjisForCell = param.kanjis?.map {
            return@map StudyActivity.KanjiForCell(it)
        }
        vocabulariesForCell = param.vocabularies?.map {
            return@map StudyActivity.VocabularyForCell(it)
        }
    }

    private fun initializeViews() {
        binding = ActivityTestResultBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.apply {
            navigationview.set(nonNull("title"), nonNull("title2"), R.drawable.img_decorate)
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
            textviewScore.text = "100점"
            textviewSubscore.text = "20/20"

            if (param.indexEnum.getSection() == SectionEnum.kanji || 0 < nonNull(kanjisForCell?.size)) {
                kanjisForCell?.let { kanjisForCell ->
                    kanjiAdapter = KanjiAdapter(this@TestResultActivity, kanjisForCell, kanjiBookmarks)
                    kanjiAdapter.setOnSelectItemListener(
                        object :
                            OnSelectItemListener {
                            override fun onSelectItem(position: Int) {
                                kanjisForCell.get(position).isVisible = !kanjisForCell.get(position).isVisible
                                kanjiAdapter.notifyItemChanged(position)
                            }
                        })
                    recyclerview.adapter = kanjiAdapter
                }
            } else if (param.indexEnum.getSection() == SectionEnum.vocabulary || 0 < nonNull(vocabulariesForCell?.size)){ // vocabulary
                vocabulariesForCell?.let { vocabulariesForCell ->
                    vocabularyAdapter = VocabularyAdapter(this@TestResultActivity, vocabulariesForCell, vocabularyBookmarks)
                    vocabularyAdapter.setOnSelectItemListener(
                        object :
                            OnSelectItemListener {
                            override fun onSelectItem(position: Int) {
                                vocabulariesForCell.get(position).isVisible = !vocabulariesForCell.get(position).isVisible
                                vocabularyAdapter.notifyItemChanged(position)
                            }
                        })
                    recyclerview.adapter = vocabularyAdapter
                }
            }
            recyclerview.addItemDecoration(
                ColorDivider(1f, 10f, this@TestResultActivity.getColor(R.color.bg4)) {
                    true
                },
            )
        }
    }
}