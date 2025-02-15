package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.ChatRoomMessagesResponseEntity
import com.constant.everydayjapanese.util.nonNull

class ChatRoomMessagesModel {
    val chatRoomId: Int
    val opponents: ArrayList<MemberModel>
    val messages: ArrayList<ChatMessageModel>
    val cursorInfo: CursorInfoModel

    constructor(chatRoomMessagesResponseEntity: ChatRoomMessagesResponseEntity) {
        this.chatRoomId = nonNull(chatRoomMessagesResponseEntity.responseData?.chatRoomId)
        this.opponents = ArrayList<MemberModel>()
        nonNull(chatRoomMessagesResponseEntity.responseData?.opponents).forEach { element ->
            this.opponents.add(MemberModel(element))
        }
        this.messages = ArrayList<ChatMessageModel>()
        nonNull(chatRoomMessagesResponseEntity.responseData?.messages).forEach { element ->
            this.messages.add(ChatMessageModel(element))
        }
        cursorInfo = CursorInfoModel(chatRoomMessagesResponseEntity?.cursorInfo)
    }

    constructor() {
        chatRoomId = 0
        opponents = ArrayList<MemberModel>()
        messages = ArrayList<ChatMessageModel>()
        cursorInfo = CursorInfoModel(null, false)
    }
}
