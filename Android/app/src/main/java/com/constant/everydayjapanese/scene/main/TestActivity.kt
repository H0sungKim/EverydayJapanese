package com.constant.everydayjapanese.scene.main

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityTestBinding
import com.constant.everydayjapanese.util.nonNull

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class TestActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    // Public Constant
    // Private Constant
    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityTestBinding

    // Override Method or Basic Method
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        initializeVariables()
        initializeViews()
    }

    // Public Method
    // Private Method

    private fun initializeVariables() {

    }

    private fun initializeViews() {
        binding = ActivityTestBinding.inflate(layoutInflater)
        setContentView(binding.root)
        binding.apply {
            navigationview.set("일본 상용 한자", "테스트", R.drawable.kanji)

            textviewCount.text = "textviewCount"
            textviewUpperSub1.text = "textviewUpperSub1"
            textviewUpperSub2.text = "textviewUpperSub2"
            textviewMain.text = "textviewMain"
            textviewLowerSub.text = "textviewLowerSub"

        }
    }
}