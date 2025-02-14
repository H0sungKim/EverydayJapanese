package com.constant.everydayjapanese.network.model

import android.os.Parcelable
import com.constant.everydayjapanese.network.entity.AddressResponseEntity
import com.constant.everydayjapanese.util.nonNull
import kotlinx.parcelize.Parcelize

@Parcelize
class AddressModel(var province: String, var city: String, var area: String) : Parcelable {
    constructor(addressEntity: AddressResponseEntity.AddressEntity) : this(
        nonNull(addressEntity.region_1depth_name),
        nonNull(addressEntity.region_2depth_name),
        nonNull(addressEntity.region_3depth_name),
    )
    constructor() : this("", "", "")
}
