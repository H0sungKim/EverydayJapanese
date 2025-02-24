package com.constant.everydayjapanese.singleton

import com.constant.everydayjapanese.network.TatoebaRepository
import com.constant.everydayjapanese.util.HHStyle

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class GlobalVariable {
    // Public Inner Class, Struct, Enum, Interface

    // ----------------------------------------------------
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: GlobalVariable

        fun getInstance(): GlobalVariable {
            synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = GlobalVariable()
                }
                return instance
            }
        }
    }

    // Public Constant
    // Private Constant

    // ----------------------------------------------------
    // Public Variable
    public var startTime: Long

    // 1일에 한번 Config 를 호출해 주기위해 만듦
    public var pingTime: Long
    public var tatoebaRepository: TatoebaRepository

    // ----------------------------------------------------
    // Private Variable
    // Override Method or Basic Method
    constructor() {
        startTime = 0
        pingTime = 0
        tatoebaRepository = TatoebaRepository(HHStyle(TatoebaRepository.Style.loadingSpinner or TatoebaRepository.Style.showErrorDialog))

    }
    // Public Method
    // Private Method
}
