package com.constant.everydayjapanese.scene.main

import android.content.Context
import android.content.Intent
import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityDayBinding
import com.constant.everydayjapanese.extension.LATER
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.model.Vocabulary
import com.constant.everydayjapanese.scene.main.StudyActivity.Companion
import com.constant.everydayjapanese.scene.main.StudyActivity.Companion.EXTRA_DAY
import com.constant.everydayjapanese.scene.main.StudyActivity.Companion.EXTRA_KANJIS_DAY_DISTRIBUTED
import com.constant.everydayjapanese.scene.main.StudyActivity.Companion.EXTRA_VOCABULARIES_DAY_DISTRIBUTED
import com.constant.everydayjapanese.scene.main.StudyActivity.Param
import com.constant.everydayjapanese.util.GlobalConst
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.IndexEnum
import com.constant.everydayjapanese.singleton.JSONManager
import com.constant.everydayjapanese.singleton.Pref
import com.constant.everydayjapanese.singleton.PrefManager
import com.constant.everydayjapanese.util.SectionEnum
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.ColorDivider
import com.constant.everydayjapanese.view.NavigationView

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface
class DayActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    interface OnSelectItemListener {
        fun onSelectItem(position: Int)
    }

    data class Param (
        var indexEnum:IndexEnum,
    )

    inner class IndexAdapter(private val context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        // Public Inner Class, Struct, Enum, Interface

        inner class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            private val imageviewIcon: ImageView = itemView.findViewById(R.id.imageview_icon)
            private val textviewTitle: TextView = itemView.findViewById(R.id.textview_title)
            private val imageviewDisclosure: ImageView = itemView.findViewById(R.id.imageview_disclosure)
            fun bind(position: Int) {
                val title:String
                if (position == 0) {
                    title = context.getString(R.string.totally_view)
                } else {
                    title = String.format(context.getString(R.string.day_number), position)
                }
                if (process[param.indexEnum.name]?.get(title) == true) {
                    imageviewIcon.setImageResource(R.drawable.img_check)
                } else {
                    imageviewIcon.setImageResource(R.drawable.img_uncheck)
                }
                textviewTitle.text = title
                imageviewDisclosure.imageTintList = ColorStateList.valueOf(ContextCompat.getColor(this@DayActivity, R.color.fg5))

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
            val view = LayoutInflater.from(context).inflate(R.layout.list_icon_title_disclosure, parent, false)
            return ItemViewHolder(view)
        }

        override fun getItemCount(): Int = nonNull(kanjisDayDistributed?.size) + nonNull(vocabulariesDayDistributed?.size) + 1

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
    } // End of IndexAdapter


    // companion object
    companion object {
        public val EXTRA_INDEX_ENUM = "EXTRA_INDEX_ENUM"
    }
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)
    private lateinit var binding: ActivityDayBinding
    private lateinit var process: HashMap<String, HashMap<String, Boolean>>
    private var kanjisDayDistributed:List<ArrayList<Kanji>>? = null
    private var vocabulariesDayDistributed:List<ArrayList<Vocabulary>>? = null
    private lateinit var indexAdapter: IndexAdapter

    // Public Variable
    // Private Variable
    private lateinit var param: Param

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
            IndexEnum.ofRaw(getIntent().getIntExtra(EXTRA_INDEX_ENUM, 0))
        )
        val jsonData = JSONManager.getInstance().loadJsonFromAsset(this@DayActivity, param.indexEnum.getFileName())
        when (param.indexEnum.getSection()) {
            SectionEnum.kanji -> {
                val kanjis:ArrayList<Kanji> = ArrayList(JSONManager.getInstance().decodeJSONtoKanjiArray(jsonData))
                HHLog.d(TAG, "kanjis = $kanjis")
                kanjisDayDistributed = (0 until kanjis.size step GlobalConst.daySize).map {
                    kanjis.subList(it, minOf(it + GlobalConst.daySize, kanjis.size)).toCollection(ArrayList())
                }
            }
            SectionEnum.vocabulary -> {
                val vocabularies:ArrayList<Vocabulary> = ArrayList(JSONManager.getInstance().decodeJSONtoVocabularyArray(jsonData))
                HHLog.d(TAG, "vocabularies = $vocabularies")
                vocabulariesDayDistributed = (0 until vocabularies.size step GlobalConst.daySize).map {
                    vocabularies.subList(it, minOf(it + GlobalConst.daySize, vocabularies.size)).toCollection(ArrayList())
                }
            }
            else -> {

            }
        }
        val processJsonData = JSONManager.getInstance().convertStringToByteArray(nonNull(PrefManager.getInstance().getStringValue(Pref.process.name)))
        processJsonData?.let { processJsonData ->
            process = JSONManager.getInstance().decodeProcessJSON(processJsonData)
        }
    }

    private fun initializeViews() {
        binding = ActivityDayBinding.inflate(layoutInflater)
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

            val total = nonNull(kanjisDayDistributed?.size) + nonNull(vocabulariesDayDistributed?.size) + 1
            val size = nonNull(process[param.indexEnum.name]).size
            progressbarProcess.setProgress(size*100/total, false)
            textviewProcess.text = String.format("%d/%d", size, total)

            indexAdapter = IndexAdapter(this@DayActivity)
            indexAdapter.setOnSelectItemListener(
                object : OnSelectItemListener {
                    override fun onSelectItem(position: Int) {
                        HHLog.d(TAG, "onSelectItem() position = $position")
                        val intent = Intent(this@DayActivity, StudyActivity::class.java)
                        intent.putExtra(StudyActivity.EXTRA_INDEX_ENUM, param.indexEnum.id)
                        if (position == 0) {
                            intent.putExtra(StudyActivity.EXTRA_DAY, getString(R.string.totally_view))
                        } else {
                            intent.putExtra(StudyActivity.EXTRA_DAY, String.format(getString(R.string.day_number), position))
                        }
                        if (position == 0) { // 전체보기
                            val jsonData = JSONManager.getInstance().loadJsonFromAsset(this@DayActivity, param.indexEnum.getFileName())
                            when (param.indexEnum.getSection()) {
                                SectionEnum.kanji -> {
                                    val kanjis:ArrayList<Kanji> = ArrayList(JSONManager.getInstance().decodeJSONtoKanjiArray(jsonData))
                                    intent.putExtra(StudyActivity.EXTRA_KANJIS_DAY_DISTRIBUTED, kanjis)
                                }
                                SectionEnum.vocabulary -> {
                                    val vocabularies:ArrayList<Vocabulary> = ArrayList(JSONManager.getInstance().decodeJSONtoVocabularyArray(jsonData))
                                    intent.putExtra(StudyActivity.EXTRA_VOCABULARIES_DAY_DISTRIBUTED, vocabularies)
                                }
                                else -> {

                                }
                            }
                        } else {    // Day
                            kanjisDayDistributed?.let {
                                if (0 < it.size) {
                                    intent.putExtra(StudyActivity.EXTRA_KANJIS_DAY_DISTRIBUTED, it.get(position-1))
                                }
                            }
                            vocabulariesDayDistributed?.let {
                                if (0 < it.size) {
                                    intent.putExtra(StudyActivity.EXTRA_VOCABULARIES_DAY_DISTRIBUTED, it.get(position-1))
                                }
                            }
                        }
                        startActivity(intent)
                    }
                },
            )
            recyclerview.adapter = indexAdapter
            recyclerview.addItemDecoration(
                ColorDivider(1f, 10f, this@DayActivity.getColor(R.color.bg4)) {
                    true
                },
            )
        }
    }
}