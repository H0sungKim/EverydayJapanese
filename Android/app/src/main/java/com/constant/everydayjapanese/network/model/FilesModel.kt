package com.constant.everydayjapanese.network.model

import com.constant.everydayjapanese.network.entity.FilesResponseEntity

class FilesModel {
    val files: ArrayList<FileModel>
    val cursorInfo: CursorInfoModel

    constructor(filesResponseEntity: FilesResponseEntity?) {
        files = ArrayList<FileModel>()
        filesResponseEntity?.responseData?.let {
            it.forEach { fileEntity ->
                files.add(FileModel(fileEntity))
            }
        }
        cursorInfo = CursorInfoModel(filesResponseEntity?.cursorInfo)
    }
}
