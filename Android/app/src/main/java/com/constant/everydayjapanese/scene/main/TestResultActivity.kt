package com.constant.everydayjapanese.scene.main

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.databinding.ActivityTestResultBinding
import com.constant.everydayjapanese.util.HHStyle
import com.constant.everydayjapanese.util.nonNull
import com.constant.everydayjapanese.view.NavigationView

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class TestResultActivity : AppCompatActivity() {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    // Private Variable
    private lateinit var binding: ActivityTestResultBinding

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

        }
    }
}