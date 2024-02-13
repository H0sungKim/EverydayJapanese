//
//  StudyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit

struct Kanji: Codable {
    let kanji: String
    let hanja: String
    let eumhun: String
    let jpSound: String
    let jpMeaning: String
}

class KanjiStudyViewController: UIViewController {
    
    var kanjis: [Kanji] = []
    var sample: String = "NO..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(kanjis)")
        // Do any additional setup after loading the view.
    }
}
