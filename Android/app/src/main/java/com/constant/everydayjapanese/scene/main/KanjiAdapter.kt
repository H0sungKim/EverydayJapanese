package com.constant.everydayjapanese.scene.main

import android.content.Context
import android.graphics.Color
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
import com.constant.everydayjapanese.extension.applyGUI
import com.constant.everydayjapanese.model.Kanji
import com.constant.everydayjapanese.scene.main.StudyActivity.KanjiForCell
import com.constant.everydayjapanese.scene.main.StudyActivity.OnSelectItemListener
import com.constant.everydayjapanese.singleton.JSONManager
import com.constant.everydayjapanese.singleton.Pref
import com.constant.everydayjapanese.singleton.PrefManager
import com.constant.everydayjapanese.singleton.TTSManager
import com.constant.everydayjapanese.util.nonNull

class KanjiAdapter(
    private val context: Context,
    private var kanjisForCell: List<KanjiForCell>,
    private var kanjiBookmarks: HashSet<Kanji>,
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
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
            val kanjiForCell = kanjisForCell.get(position)
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
                notifyItemChanged(position)
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
                notifyItemChanged(position)
            }
            val marginHorizontal = context.resources.getDimensionPixelSize(R.dimen.space_m)
            val marginVertical = context.resources.getDimensionPixelSize(R.dimen.space_x3s)
            linearlayoutExample.removeAllViews()
            kanjiForCell.kanji.examples.forEach { vocabulary ->
                val linearLayoutH = LinearLayout(context).apply {
                    orientation = LinearLayout.HORIZONTAL
                    layoutParams = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    ).apply {
//                                setMargins(marginHorizontal, marginVertical, marginHorizontal, marginVertical)
                        setPadding(marginHorizontal, marginVertical, marginHorizontal, marginVertical)
                    }
                }

                val linearLayoutV = LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    layoutParams = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                }

                val textViewSound = TextView(context).apply {
                    text = vocabulary.sound
                    applyGUI(R.style.font_p5, R.color.fg3)
                    layoutParams = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                }
                val textViewWord = TextView(context).apply {
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
                val view = View(context).apply {
                    layoutParams = LinearLayout.LayoutParams(
                        0,
                        0,
                        1f
                    )
                }
                val textViewMeaning = TextView(context).apply {
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
            if (kanjiForCell.isVisible || isAllVisible) {
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
    private val TAG = nonNull(this::class.simpleName)
    private val item: Int = 0
    private var isAllVisible: Boolean = false

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

    override fun getItemCount(): Int = kanjisForCell.size

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

    fun toggleAllVisible() {
        isAllVisible = !isAllVisible
        notifyDataSetChanged()
    }
}
