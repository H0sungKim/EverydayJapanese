package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.ClubChatMessagesResponseEntity
import com.constant.everydayjapanese.util.nonNull

class ClubChatMessagesModel {
    val chatMessages: ArrayList<ChatMessageModel>
    val cursorInfo: CursorInfoModel

    constructor(clubChatMessagesResponseEntity: ClubChatMessagesResponseEntity) {
        this.chatMessages = ArrayList<ChatMessageModel>()
        nonNull(clubChatMessagesResponseEntity.responseData).forEach { element ->
            this.chatMessages.add(ChatMessageModel(element))
        }
        cursorInfo = CursorInfoModel(clubChatMessagesResponseEntity.cursorInfo)
    }
}
