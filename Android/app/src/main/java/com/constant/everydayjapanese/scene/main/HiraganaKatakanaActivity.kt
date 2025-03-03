package com.constant.everydayjapanese.scene.main

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityHiraganaKatakanaBinding
import com.constant.everydayjapanese.singleton.HiraganaKatakanaManager
import com.constant.everydayjapanese.util.Coordinate
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.IndexEnum
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.NavigationView


// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface


class HiraganaKatakanaActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    data class Param (
        var indexEnum: IndexEnum,
    )

    interface OnSelectItemListener {
        fun onSelectItem(position: Int)
    }

    inner class HiraganaKatakanaAdapter(private val context: Context) :
        RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        // Public Inner Class, Struct, Enum, Interface
        inner class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            val textviewMain: TextView = itemView.findViewById(R.id.textview_main)
            val textviewSub: TextView = itemView.findViewById(R.id.textview_sub)

            fun bind(position: Int) {
                textviewMain.text = items.get(position).first
                textviewSub.text = items.get(position).second
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
            HHLog.d(TAG, "onCreateViewHolder()")
            val view = LayoutInflater.from(context).inflate(R.layout.grid_hiragana_katakana, parent, false)
            return ItemViewHolder(view)
        }

        override fun getItemCount(): Int = items.size

        override fun getItemViewType(position: Int): Int {
            return item
        }

        override fun onBindViewHolder(
            holder: RecyclerView.ViewHolder,
            position: Int,
        ) {
            val itemViewHolder: ItemViewHolder = holder as ItemViewHolder
            HHLog.d(TAG, "onBindViewHolder() position = $position")
            itemViewHolder.bind(position)
        }

        // Public Method
        fun setOnSelectItemListener(onSelectItemListener: OnSelectItemListener) {
            this.onSelectItemListener = onSelectItemListener
        }
        // Public Method
    } // end of AlphabetAdapter


    // companion object
    companion object {
        public val EXTRA_INDEX_ENUM = "EXTRA_INDEX_ENUM"
    }
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityHiraganaKatakanaBinding

    private lateinit var param: Param
    private lateinit var hiraganaKatakanaAdapter: HiraganaKatakanaAdapter
    private lateinit var items: List<Pair<String, String>>

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
            IndexEnum.ofRaw(getIntent().getIntExtra(StudyActivity.EXTRA_INDEX_ENUM, 0))
        )

        when (param.indexEnum) {
            IndexEnum.hiragana -> {
                items = HiraganaKatakanaManager.getInstance().hiraganaTuple
            }
            IndexEnum.katakana -> {
                items = HiraganaKatakanaManager.getInstance().katakanaTuple
            }
            else -> {

            }
        }
    }

    private fun initializeViews() {
        binding = ActivityHiraganaKatakanaBinding.inflate(layoutInflater)
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
            val gridLayoutManager = GridLayoutManager(this@HiraganaKatakanaActivity, getSpanCount())

            hiraganaKatakanaAdapter = HiraganaKatakanaAdapter(this@HiraganaKatakanaActivity)
            recyclerview.adapter = hiraganaKatakanaAdapter
            recyclerview.setLayoutManager(gridLayoutManager)
            hiraganaKatakanaAdapter.notifyDataSetChanged()
        }
    }

    private fun getSpanCount(): Int {
        // 화면의 가로 길이와 아이템의 최소 너비를 사용하여 spanCount 계산
//        val shortAxis = Coordinate.getShortAxis()
//        val albumWidth = resources.getDimension(R.dimen.album_picture_size_m).toInt()
//        return shortAxis / albumWidth
        return 5
    }
}