package com.constant.everydayjapanese.singleton

import com.constant.everydayjapanese.network.CommonRepository
import com.constant.everydayjapanese.network.KakaoRepository
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
    public var commonRepository: CommonRepository
    public var noErrorRepository: CommonRepository
    public var noloadingRepository: CommonRepository
    public var noStyleRepository: CommonRepository
    public var kakaoRepository: KakaoRepository
    public var tatoebaRepository: TatoebaRepository

    // ----------------------------------------------------
    // Private Variable
    // Override Method or Basic Method
    constructor() {
        startTime = 0
        pingTime = 0
        commonRepository = CommonRepository(HHStyle(CommonRepository.Style.loadingSpinner or CommonRepository.Style.showErrorDialog))
        noErrorRepository = CommonRepository(HHStyle(CommonRepository.Style.loadingSpinner))
        noloadingRepository = CommonRepository(HHStyle(CommonRepository.Style.showErrorDialog))
        noStyleRepository = CommonRepository(HHStyle(CommonRepository.Style.none))
        kakaoRepository = KakaoRepository(HHStyle(KakaoRepository.Style.loadingSpinner or KakaoRepository.Style.showErrorDialog))
        tatoebaRepository = TatoebaRepository(HHStyle(TatoebaRepository.Style.loadingSpinner or TatoebaRepository.Style.showErrorDialog))

    }
    // Public Method
    // Private Method
}
