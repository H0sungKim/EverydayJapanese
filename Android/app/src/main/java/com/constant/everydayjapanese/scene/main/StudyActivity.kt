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
    inner class KanjiAdapter(private val context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        // Public Inner Class, Struct, Enum, Interface

        inner class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            private val textviewSound: TextView = itemView.findViewById(R.id.textview_sound)
            private val textviewMeaning: TextView = itemView.findViewById(R.id.textview_meaning)
            private val textviewKanji: TextView = itemView.findViewById(R.id.textview_kanji)
            private val textviewEumhun: TextView = itemView.findViewById(R.id.textview_eumhun)
            private val buttonBookmark: ImageButton = itemView.findViewById(R.id.button_bookmark)
            private val buttonSound: ImageButton = itemView.findViewById(R.id.button_sound)
            private val buttonExpand: ImageButton = itemView.findViewById(R.id.button_expand)
            private val linearlayoutExample: LinearLayout = itemView.findViewById(R.id.linearlayout_example)

            fun bind(position: Int) {
                kanjisForCell?.get(position)?.let { kanjiForCell ->
                    textviewSound.text = kanjiForCell.kanji.jpSound
                    textviewMeaning.text = kanjiForCell.kanji.jpMeaning
                    textviewKanji.text = kanjiForCell.kanji.kanji
                    textviewEumhun.text = kanjiForCell.kanji.eumhun
                    if (kanjiForCell.isBookmark) {
                        buttonBookmark.setImageResource(R.drawable.img_favorite_on)
                    } else {
                        buttonBookmark.setImageResource(R.drawable.img_favorite_off)
                    }
                    buttonBookmark.setOnClickListener {
                        if (kanjiForCell.isBookmark) {
                            kanjiBookmarks.remove(kanjiForCell.kanji)
                        } else {
                            kanjiBookmarks.add(kanjiForCell.kanji)
                        }
                        kanjiForCell.isBookmark = !kanjiForCell.isBookmark
                        kanjiAdapter.notifyItemChanged(position)
                        PrefManager.getInstance().setValue(Pref.kanjiBookmark.name, JSONManager.getInstance().encodeKanjiJSON(kanjiBookmarks))

                    }
                    buttonSound.setOnClickListener {
                        TTSManager.getInstance().speak(kanjiForCell.kanji.jpSound + "\n" + kanjiForCell.kanji.jpMeaning)
                    }
                    if (kanjiForCell.isExpanded) {
                        buttonExpand.setImageResource(R.drawable.img_up)
                    } else {
                        buttonExpand.setImageResource(R.drawable.img_down)
                    }
                    buttonExpand.setOnClickListener {
                        kanjiForCell.isExpanded = !kanjiForCell.isExpanded
                        kanjiAdapter.notifyItemChanged(position)
                    }
                    val marginHorizontal = resources.getDimensionPixelSize(R.dimen.space_m)
                    val marginVertical = resources.getDimensionPixelSize(R.dimen.space_x3s)
                    linearlayoutExample.removeAllViews()
                    kanjiForCell.kanji.examples.forEach { vocabulary ->
                        val linearLayoutH = LinearLayout(this@StudyActivity).apply {
                            orientation = LinearLayout.HORIZONTAL
                            layoutParams = LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            ).apply {
//                                setMargins(marginHorizontal, marginVertical, marginHorizontal, marginVertical)
                                setPadding(marginHorizontal, marginVertical, marginHorizontal, marginVertical)
                            }
                        }

                        val linearLayoutV = LinearLayout(this@StudyActivity).apply {
                            orientation = LinearLayout.VERTICAL
                            layoutParams = LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.WRAP_CONTENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            )
                        }

                        val textViewSound = TextView(this@StudyActivity).apply {
                            text = vocabulary.sound
                            applyGUI(R.style.font_p5, R.color.fg3)
                            layoutParams = LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.WRAP_CONTENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            )
                        }
                        val textViewWord = TextView(this@StudyActivity).apply {
                            text = vocabulary.word
                            applyGUI(R.style.font_p2, R.color.fg0)
                            layoutParams = LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.WRAP_CONTENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            ).apply {
                                setMargins(0, 0, 0, resources.getDimensionPixelSize(R.dimen.space_x4s))
                            }
                        }
                        linearLayoutV.addView(textViewSound)
                        linearLayoutV.addView(textViewWord)
                        val view = View(this@StudyActivity).apply {
                            layoutParams = LinearLayout.LayoutParams(
                                0,
                                0,
                                1f
                            )
                        }
                        val textViewMeaning = TextView(this@StudyActivity).apply {
                            text = vocabulary.meaning
                            applyGUI(R.style.font_p4, R.color.fg0)
                            layoutParams = LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.WRAP_CONTENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT
                            ).apply {
                                gravity = Gravity.CENTER_VERTICAL
                            }
                        }
                        linearLayoutH.addView(linearLayoutV)
                        linearLayoutH.addView(view)
                        linearLayoutH.addView(textViewMeaning)
                        linearlayoutExample.addView(linearLayoutH)
                    }
                    if (kanjiForCell.isVisible) {
                        textviewSound.visibility = View.VISIBLE
                        textviewMeaning.visibility = View.VISIBLE
                        textviewEumhun.visibility = View.VISIBLE
                    } else {
                        textviewSound.visibility = View.INVISIBLE
                        textviewMeaning.visibility = View.INVISIBLE
                        textviewEumhun.visibility = View.INVISIBLE
                    }
                    if (kanjiForCell.isExpanded) {
                        linearlayoutExample.visibility= View.VISIBLE
                    } else {
                        linearlayoutExample.visibility= View.GONE
                    }
                }
                itemView.setOnClickListener {
                    onSelectItemListener?.onSelectItem(position)
                }

                itemView.setOnTouchListener { v, event ->
                    if (event.action == MotionEvent.ACTION_DOWN) {
                        v.setBackgroundColor(context.getColor(R.color.list_selection))
                    }
                    if (event.action == MotionEvent.ACTION_UP || event.action == MotionEvent.ACTION_CANCEL) {
                        v.setBackgroundColor(Color.TRANSPARENT)
                    }
                    false
                }
            }
        }

        // Private Constant
        private val item: Int = 0

        // Public Variable

        // Private Variable
        private var onSelectItemListener: OnSelectItemListener? = null
        // Override Method or Basic Method
        override fun onCreateViewHolder(
            parent: ViewGroup,
            viewType: Int,
        ): RecyclerView.ViewHolder {
            val view = LayoutInflater.from(context).inflate(R.layout.list_kanji, parent, false)
            return ItemViewHolder(view)
        }

        override fun getItemCount(): Int = nonNull(kanjisForCell?.size)

        override fun getItemViewType(position: Int): Int {
            return item
        }

        override fun onBindViewHolder(
            holder: RecyclerView.ViewHolder,
            position: Int,
        ) {
            val itemViewHolder: ItemViewHolder = holder as ItemViewHolder
            itemViewHolder.bind(position)
        }

        // Public Method
        fun setOnSelectItemListener(onSelectItemListener: OnSelectItemListener) {
            this.onSelectItemListener = onSelectItemListener
        }
    } // End of KanjiAdapter





    inner class VocabularyAdapter(private val context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        // Public Inner Class, Struct, Enum, Interface

        inner class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            private val textviewSound: TextView = itemView.findViewById(R.id.textview_sound)
            private val textviewWord: TextView = itemView.findViewById(R.id.textview_word)
            private val textviewMeaning: TextView = itemView.findViewById(R.id.textview_meaning)
            private val buttonBookmark: ImageButton = itemView.findViewById(R.id.button_bookmark)
            private val buttonSound: ImageButton = itemView.findViewById(R.id.button_sound)
            private val buttonExpand: ImageButton = itemView.findViewById(R.id.button_expand)
            private val linearlayoutExample: LinearLayout = itemView.findViewById(R.id.linearlayout_example)
            private val textViewExample: TextView = itemView.findViewById(R.id.textview_example)
            fun bind(position: Int) {
                vocabulariesForCell?.get(position)?.let { vocabularyForCell ->
                    textviewSound.text = vocabularyForCell.vocabulary.sound
                    textviewWord.text = vocabularyForCell.vocabulary.word
                    textviewMeaning.text = vocabularyForCell.vocabulary.meaning

                    if (vocabularyForCell.isBookmark) {
                        buttonBookmark.setImageResource(R.drawable.img_favorite_on)
                    } else {
                        buttonBookmark.setImageResource(R.drawable.img_favorite_off)
                    }
                    buttonBookmark.setOnClickListener {
                        if (vocabularyForCell.isBookmark) {
                            vocabularyBookmarks.remove(vocabularyForCell.vocabulary)
                        } else {
                            vocabularyBookmarks.add(vocabularyForCell.vocabulary)
                        }
                        vocabularyForCell.isBookmark = !vocabularyForCell.isBookmark
                        vocabularyAdapter.notifyItemChanged(position)
                        PrefManager.getInstance().setValue(Pref.vocabularyBookmark.name, JSONManager.getInstance().encodeVocabularyJSON(vocabularyBookmarks))
                    }
                    buttonSound.setOnClickListener {
                        TTSManager.getInstance().speak(vocabularyForCell.vocabulary.word)
                    }
                    if (vocabularyForCell.isExpanded) {
                        buttonExpand.setImageResource(R.drawable.img_up)
                    } else {
                        buttonExpand.setImageResource(R.drawable.img_down)
                    }
                    buttonExpand.setOnClickListener {
                        if (vocabularyForCell.isExpanded) {
                            vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
                            vocabularyAdapter.notifyItemChanged(position)
                        } else {
                            if (vocabularyForCell.exampleText == null) {
//                                vocabularyForCell.exampleText = "<ruby>Android<rt>アンドロイド</rt></ruby>は、<ruby>Google<rt>グーグル</rt></ruby>が<ruby>開発<rt>かいはつ</rt></ruby>した<ruby>携帯汎用<rt>けいたいはんよう</rt></ruby>안녕"
//                                vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
//                                vocabularyAdapter.notifyItemChanged(position)

                                GlobalVariable.getInstance().tatoebaRepository.getSentence(this@StudyActivity, vocabularyForCell.vocabulary.word)
                                    .subscribe({ sentenceModel ->
                                        HHLog.d(TAG, "sentenceModel.html = ${sentenceModel.html}")
                                        //vocabularyForCell.exampleText = sentenceModel.html.replace("<rp>（</rp>", "").replace("<rp>）</rp>", "")
                                        vocabularyForCell.exampleText = sentenceModel.text
                                        vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
                                        vocabularyAdapter.notifyItemChanged(position)
                                    }, {

                                    }).let { compositeDisposable.add(it) }
                            } else {
                                vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
                                vocabularyAdapter.notifyItemChanged(position)
                            }
                        }
                    }
                    vocabularyForCell.exampleText?.let {
                        //textViewExample.setFuriganaText(it, true)
                        textViewExample.text = it
                    }

                    if (vocabularyForCell.isVisible) {
                        textviewSound.visibility = View.VISIBLE
                        textviewMeaning.visibility = View.VISIBLE
                    } else {
                        textviewSound.visibility = View.INVISIBLE
                        textviewMeaning.visibility = View.INVISIBLE
                    }
                    if (vocabularyForCell.isExpanded) {
                        linearlayoutExample.visibility = View.VISIBLE
                    } else {
                        linearlayoutExample.visibility = View.GONE
                    }
                }

                itemView.setOnClickListener {
                    onSelectItemListener?.onSelectItem(position)
                }

                itemView.setOnTouchListener { v, event ->
                    if (event.action == MotionEvent.ACTION_DOWN) {
                        v.setBackgroundColor(context.getColor(R.color.list_selection))
                    }
                    if (event.action == MotionEvent.ACTION_UP || event.action == MotionEvent.ACTION_CANCEL) {
                        v.setBackgroundColor(Color.TRANSPARENT)
                    }
                    false
                }
            }
        }

        // Private Constant
        private val item: Int = 0

        // Public Variable

        // Private Variable
        private var onSelectItemListener: OnSelectItemListener? = null
        // Override Method or Basic Method
        override fun onCreateViewHolder(
            parent: ViewGroup,
            viewType: Int,
        ): RecyclerView.ViewHolder {
            val view = LayoutInflater.from(context).inflate(R.layout.list_vocabulary, parent, false)
            return ItemViewHolder(view)
        }

        override fun getItemCount(): Int = nonNull(vocabulariesForCell?.size)

        override fun getItemViewType(position: Int): Int {
            return item
        }

        override fun onBindViewHolder(
            holder: RecyclerView.ViewHolder,
            position: Int,
        ) {
            val itemViewHolder: ItemViewHolder = holder as ItemViewHolder
            itemViewHolder.bind(position)
        }

        // Public Method
        fun setOnSelectItemListener(onSelectItemListener: OnSelectItemListener) {
            this.onSelectItemListener = onSelectItemListener
        }
    } // End of VocabularyAdapter


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
                kanjiAdapter = KanjiAdapter(this@StudyActivity)
                kanjiAdapter.setOnSelectItemListener(
                    object : OnSelectItemListener {
                        override fun onSelectItem(position: Int) {
                            kanjisForCell?.get(position)?.isVisible = !nonNull(kanjisForCell?.get(position)?.isVisible)
                            kanjiAdapter.notifyItemChanged(position)
                        }
                    })
                recyclerview.adapter = kanjiAdapter
            } else if (param.indexEnum.getSection() == SectionEnum.vocabulary || 0 < nonNull(vocabulariesForCell?.size)){ // vocabulary
                vocabularyAdapter = VocabularyAdapter(this@StudyActivity)
                vocabularyAdapter.setOnSelectItemListener(
                    object : OnSelectItemListener {
                        override fun onSelectItem(position: Int) {
                            vocabulariesForCell?.get(position)?.isVisible = !nonNull(vocabulariesForCell?.get(position)?.isVisible)
                            vocabularyAdapter.notifyItemChanged(position)
                        }
                    })
                recyclerview.adapter = vocabularyAdapter
            }
            recyclerview.addItemDecoration(
                ColorDivider(1f, 10f, this@StudyActivity.getColor(R.color.bg4)) {
                    true
                },
            )
        }
    }
}