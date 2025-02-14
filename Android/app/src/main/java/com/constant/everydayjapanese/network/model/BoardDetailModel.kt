package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.extension.toLocalDateTime
import com.constant.everydayjapanese.network.entity.BoardDetailResponseEntity
import com.constant.everydayjapanese.util.MimeType
import com.constant.everydayjapanese.util.nonNull
import java.time.LocalDateTime

class BoardDetailModel {
    val id: Int
    val content: String
    val createdDate: LocalDateTime
    val hit: Int
    val commentCount: Int
    var likeCount: Int
    var likeOn: Boolean
    val member: MemberModel
    val files: ArrayList<FileModel>
    val youtubeLinks: ArrayList<String>

    constructor(boardDetailResponseEntity: BoardDetailResponseEntity) {
        this.id = nonNull(boardDetailResponseEntity.responseData?.id)
        this.content = nonNull(boardDetailResponseEntity.responseData?.content)
        this.createdDate = nonNull(boardDetailResponseEntity.responseData?.createdDate).toLocalDateTime()
        this.hit = nonNull(boardDetailResponseEntity.responseData?.hit)
        this.commentCount = nonNull(boardDetailResponseEntity.responseData?.commentCount)
        this.likeCount = nonNull(boardDetailResponseEntity.responseData?.likeCount)
        this.likeOn = nonNull(boardDetailResponseEntity.responseData?.likeOn)
        this.member = MemberModel(boardDetailResponseEntity.responseData?.member)

        val onlyImages =
            nonNull(boardDetailResponseEntity.responseData?.files).map {
                FileModel(it)
            }.filter {
                it.mimeType == MimeType.image
            }
        val onlyVideos =
            nonNull(boardDetailResponseEntity.responseData?.files).map {
                FileModel(it)
            }.filter {
                it.mimeType == MimeType.video
            }
        this.files = ArrayList(onlyImages)
        this.files.addAll(onlyVideos)
        this.youtubeLinks = ArrayList<String>()
        this.youtubeLinks.addAll(nonNull(boardDetailResponseEntity.responseData?.youtubeLinks))
    }

    constructor() {
        this.id = 0
        this.content = ""
        this.createdDate = LocalDateTime.now()
        this.hit = 0
        this.commentCount = 0
        this.likeCount = 0
        this.likeOn = false
        this.member = MemberModel()
        this.files = ArrayList()
        this.youtubeLinks = ArrayList()
    }
}
