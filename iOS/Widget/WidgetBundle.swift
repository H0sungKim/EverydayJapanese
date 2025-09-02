//
//  WidgetBundle.swift
//  Widget
//
//  Created by 김호성 on 2025.09.01.
//

import WidgetKit
import SwiftUI

@main
struct MNWidgetBundle: WidgetBundle {
    var body: some Widget {
        KanjiWidget()
        JLPTWidget()
    }
}
