package com.constant.everydayjapanese.network

import android.content.Context
import com.constant.everydayjapanese.R
import com.constant.everydayjapanese.dialog.LoadingDialog
import com.constant.everydayjapanese.scene.common.HHDialog
import com.constant.everydayjapanese.util.*
import io.reactivex.rxjava3.core.ObservableEmitter
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.net.SocketTimeoutException

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface
open class HHResponse<T : Any>(
    private val context: Context,
    private val style: HHStyle,
    private val loadingDialog: LoadingDialog?,
    private val emitter: ObservableEmitter<T>,
) : Callback<T> {
    // Public Inner Class, Struct, Enum, Interface
    // companion object
    // Public Constant
    private val TAG = nonNull(this::class.simpleName)
    // Private Constant
    // Public Variable
    // Private Variable

    // ----------------------------------------------------
    // Override Method or Basic Method
    override fun onResponse(
        call: Call<T>,
        response: Response<T>,
    ) {
        HHLog.d(TAG, "onResponse()")
        if (style.isInclude(TatoebaRepository.Style.loadingSpinner)) {
            loadingDialog?.dismiss()
        }
        if (response.isSuccessful) {
            HHLog.d(TAG, "success ${response.body()}")
            response.body()?.let { emitter.onNext(it) }
            emitter.onComplete()
        } else {
            val error = getHHError(response)
            if (error == HHError.OTHERS) {
                if (style.isInclude(TatoebaRepository.Style.showErrorDialog)) {
                    HHDialog(
                        context,
                        null,
                        context.getString(R.string.network_connection_is_poor),
                        context.getString(R.string.common_ok),
                    )
                }
            }
            HHLog.e(TAG, "error!!! response.code() = ${response.code()}, response.body() = ${response.body()}, error = $error")
            // emitter.onError(Throwable("${error.name}", error))
            emitter.onError(Throwable("${error.name}"))
        }
    }

    override fun onFailure(
        call: Call<T>,
        throwable: Throwable,
    ) {
        HHLog.e(TAG, "failure, call = $call, t = $throwable")
        if (style.isInclude(TatoebaRepository.Style.loadingSpinner)) {
            loadingDialog?.dismiss()
        }
        if (style.isInclude(TatoebaRepository.Style.showErrorDialog)) {
            if (throwable is SocketTimeoutException) {
                HHDialog(
                    context,
                    null,
                    context.getString(R.string.no_response_from_server),
                    context.getString(R.string.common_ok),
                )
            } else {
                HHDialog(
                    context,
                    null,
                    context.getString(R.string.network_connection_is_poor),
                    context.getString(R.string.common_ok),
                )
            }
        }
        emitter.onError(throwable)
    }

    // Public Method
    // Private Method
}
