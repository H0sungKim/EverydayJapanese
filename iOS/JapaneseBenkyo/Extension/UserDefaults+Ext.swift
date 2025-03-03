//
//  UserDefaults+Ext.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.03.03.
//

import Foundation

extension UserDefaults {
    static var grouped: UserDefaults {
        let appGroupId = "group.com.constant.mainichinihongo"
        return UserDefaults(suiteName: appGroupId)!
    }
}
