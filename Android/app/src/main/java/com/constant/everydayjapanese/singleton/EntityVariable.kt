package com.constant.everydayjapanese.singleton

import com.constant.everydayjapanese.network.model.ConfigModel

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface
class EntityVariable {
    // Public Inner Class, Struct, Enum, Interface
    // ----------------------------------------------------
    // companion object
    companion object {
        @Volatile
        private lateinit var instance: EntityVariable

        fun getInstance(): EntityVariable {
            synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = EntityVariable()
                }
                return instance
            }
        }
    }

    // Public Constant
    // Private Constant
    // Public Variable
    var configModel: ConfigModel?

    // Private Variable
    // Override Method or Basic Method
    constructor() {
        configModel = null
    }
    // Public Method
    // Private Method
}
