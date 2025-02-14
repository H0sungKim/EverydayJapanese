package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.ClubsResponseEntity
import com.constant.everydayjapanese.util.nonNull

class ClubModel {
    var id: Int
    var name: String
    var description: String
    var maxNumPeople: Int
    var thumbnailUrl: String

    var province: String
    var city: String
    var area: String

    var latitude: Double
    var longitude: Double

    constructor(clubEntity: ClubsResponseEntity.ClubEntity) {
        this.id = nonNull(clubEntity.id)
        this.name = nonNull(clubEntity.name)
        this.description = nonNull(clubEntity.description)
        this.maxNumPeople = nonNull(clubEntity.maxNumPeople)
        this.thumbnailUrl = nonNull(clubEntity.thumbnailUrl)

        this.province = nonNull(clubEntity.province)
        this.city = nonNull(clubEntity.city)
        this.area = nonNull(clubEntity.area)

        this.latitude = nonNull(clubEntity.latitude)
        this.longitude = nonNull(clubEntity.longitude)
    }
}
