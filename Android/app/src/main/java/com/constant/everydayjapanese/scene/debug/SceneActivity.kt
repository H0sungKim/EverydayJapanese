package com.constant.everydayjapanese.scene.debug

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.RecyclerView
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivitySceneBinding
import com.constant.everydayjapanese.scene.main.HiraganaKatakanaActivity
import com.constant.everydayjapanese.scene.main.HiraganaKatakanaPracticeActivity
import com.constant.everydayjapanese.scene.main.TestResultActivity
import com.constant.everydayjapanese.util.FeatureConst
import com.constant.everydayjapanese.util.GlobalConst
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.NavigationView

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class SceneActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    data class Item (
        var name: String,
        var cls: Class<*>
    )
    interface OnSelectItemListener {
        fun onSelectItem(position: Int)
    }

    inner class SceneAdapter(private val context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        inner class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            private val textviewTitle: TextView = itemView.findViewById(R.id.textview_title)
            fun bind(position: Int) {
                items?.get(position)?.let { item ->
                    textviewTitle.text = item.name
                }
                itemView.setOnClickListener {
                    onSelectItemListener?.onSelectItem(position)
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
            val view = LayoutInflater.from(context).inflate(R.layout.list_title, parent, false)
            return ItemViewHolder(view)
        }

        override fun getItemCount(): Int {
            HHLog.d(TAG, "${nonNull(items?.size)}")
            return nonNull(items?.size)
        }

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
    } // End of SceneAdapter

    // companion object
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivitySceneBinding
    private lateinit var items: ArrayList<Item>
    private lateinit var sceneAdapter: SceneAdapter

    // Override Method or Basic Method
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initializeVariables()
        initializeViews()
    }
    // Public Method
    // Private Method
    private fun initializeVariables() {
        items = ArrayList<Item>()
        items.add(Item("TestResult", TestResultActivity::class.java))
        items.add(Item("HiraganaKatakana", HiraganaKatakanaActivity::class.java))
        items.add(Item("HiraganaKatakanaPractice", HiraganaKatakanaPracticeActivity::class.java))
    }

    private fun initializeViews() {
        binding = ActivitySceneBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.apply {
            navigationview.set("Scene", "Scene", R.drawable.star)
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

            sceneAdapter = SceneAdapter(this@SceneActivity)
            sceneAdapter.setOnSelectItemListener(
                object :
                    OnSelectItemListener {
                    override fun onSelectItem(position: Int) {
                        items?.get(position)?.let { item ->
                            HHLog.d(TAG, "name = ${item.name}")
                            //sceneAdapter.notifyItemChanged(position)
                            val intent = Intent(this@SceneActivity, item.cls)
                            startActivity(intent)
                        }
                    }
                })
            recyclerview.adapter = sceneAdapter
            sceneAdapter.notifyDataSetChanged()

            if (FeatureConst.FEATURE_SPECIFIC_SCENE) {
                val intent = Intent(this@SceneActivity, HiraganaKatakanaPracticeActivity::class.java)
                startActivity(intent)
            }
        }
    }
}