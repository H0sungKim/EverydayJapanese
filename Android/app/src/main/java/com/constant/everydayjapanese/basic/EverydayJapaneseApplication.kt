package com.constant.everydayjapanese.basic

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.constant.everydayjapanese.singleton.DebugVariable
import com.constant.everydayjapanese.singleton.GlobalVariable
import com.constant.everydayjapanese.singleton.Pref
import com.constant.everydayjapanese.singleton.PrefManager
import com.constant.everydayjapanese.util.FeatureConst
import com.constant.everydayjapanese.util.HHIntent
import com.constant.everydayjapanese.util.HHLog
import com.constant.everydayjapanese.util.nonNull

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

class EverydayJapaneseApplication : Application() {
    // Public Inner Class, Struct, Enum, Interface
    class AppLifecycleTracker(private val context: Context) : Application.ActivityLifecycleCallbacks {
        private val TAG = nonNull(this::class.simpleName)
        public var numStartedActivity = 0

        override fun onActivityStarted(activity: Activity) {
            HHLog.d(TAG, "onActivityStarted")
            numStartedActivity++
            // app went to foreground
            if (DebugVariable.getInstance().isShowDebugText) {
                val intent = Intent()
                intent.action = HHIntent.ACTION_DEBUG_WINDOW_SHOW
                context.sendBroadcast(intent)
            }
        }

        override fun onActivityStopped(activity: Activity) {
            HHLog.d(TAG, "onActivityStopped")
            numStartedActivity--
            if (numStartedActivity == 0) {
                // app went to background
                val intent = Intent()
                intent.action = HHIntent.ACTION_DEBUG_WINDOW_HIDE
                context.sendBroadcast(intent)
            }
        }

        override fun onActivityCreated(
            p0: Activity,
            p1: Bundle?,
        ) {
            // TODO("Not yet implemented")
        }

        override fun onActivityResumed(p0: Activity) {
            // TODO("Not yet implemented")
        }

        override fun onActivityPaused(p0: Activity) {
            // TODO("Not yet implemented")
        }

        override fun onActivitySaveInstanceState(
            p0: Activity,
            p1: Bundle,
        ) {
            // TODO("Not yet implemented")
        }

        override fun onActivityDestroyed(p0: Activity) {
            // TODO("Not yet implemented")
        }
    }

//    class AppLifecycleObserver(private val context: Context) : DefaultLifecycleObserver {
//        override fun onStop(owner: LifecycleOwner) {
//            // 앱이 백그라운드로 전환될 때 시간 저장
//        }
//
//        override fun onStart(owner: LifecycleOwner) {
//            // 앱이 포그라운드로 돌아올 때 시간 확인
//            BootingManager.getInstance().resume(context)
//        }
//    }

    // companion object
    companion object {
        lateinit var context: Context
    }

    // Public Constant
    // Private Constant
    private val TAG = nonNull(this::class.simpleName)

    // Public Variable
    var appLifecycleTracker: AppLifecycleTracker? = null

    // Private Variable
    // Override Method or Basic Method
    override fun onCreate() {
        super.onCreate()
        context = this
        FeatureConst.initialize(context)

        initializePreference()

        GlobalVariable.getInstance().startTime = System.currentTimeMillis()
        GlobalVariable.getInstance().pingTime = System.currentTimeMillis()

        HHLog.d(TAG, "[TIME] App Start : ${System.currentTimeMillis() - GlobalVariable.getInstance().startTime}")
        HHLog.d(TAG, "AttendanceApplication.onCreate()")

        appLifecycleTracker =
            AppLifecycleTracker(this)
        registerActivityLifecycleCallbacks(appLifecycleTracker)

        //ProcessLifecycleOwner.get().lifecycle.addObserver(AppLifecycleObserver(this))
        HHLog.d(TAG, "[TIME] App onCreate()Finished : ${System.currentTimeMillis() - GlobalVariable.getInstance().startTime}")

    }

    // Public Method
    fun isActivityVisible(): Boolean {
        return appLifecycleTracker!!.numStartedActivity != 0
    }

    // Private Method
    private fun initializePreference() {
        PrefManager.getInstance().registerPreference(context)
        DebugVariable.getInstance().isLogEnable = PrefManager.getInstance().getBooleanValue(Pref.logEnable.name)
        DebugVariable.getInstance().isShowDebugText = PrefManager.getInstance().getBooleanValue(Pref.showDebugText.name)
        PrefManager.getInstance().printPreference()
    }
}
