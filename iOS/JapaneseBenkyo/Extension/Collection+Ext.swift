//
//  Collection+Ext.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.09.14.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
