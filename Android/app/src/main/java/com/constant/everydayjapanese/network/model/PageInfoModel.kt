package com.constant.everydayjapanese.network.model

import android.os.Parcelable
import com.constant.everydayjapanese.network.entity.PageInfoEntity
import com.constant.everydayjapanese.util.nonNull
import kotlinx.parcelize.Parcelize

@Parcelize
class PageInfoModel(
    var totalPages: Int,
    var currentPage: Int,
    var totalRows: Int,
    var pageSize: Int,
) : Parcelable {
    constructor() : this(
        0,
        0,
        0,
        0,
    ) {
    }

    constructor(pageInfoEntity: PageInfoEntity?) : this(
        nonNull(pageInfoEntity?.totalPages),
        nonNull(pageInfoEntity?.currentPage),
        nonNull(pageInfoEntity?.totalRows),
        nonNull(pageInfoEntity?.pageSize),
    ) {
    }
}
