package com.constant.everydayjapanese.scene.main

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.constant.everydayjapanese.databinding.ActivityHiraganaKatakanaBinding
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

        }
    }
}