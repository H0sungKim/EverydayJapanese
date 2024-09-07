//
//  KanjiTestViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/16/24.
//

import UIKit

class KanjiTestViewController: UIViewController {
    var kanjis: [Kanji] = []
    var level: String = ""
    var day: String = ""
    
    private var testResult: [Bool] = []
    private var index: Int = 0
    private var isKanjiVisible: Bool = false
    
    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var lbKanji: UILabel!
    @IBOutlet weak var lbHanja: UILabel!
    @IBOutlet weak var lbEumhun: UILabel!
    @IBOutlet weak var lbJpSound: UILabel!
    @IBOutlet weak var lbJpMeaning: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        kanjis.shuffle()
        lbTitle.text = "\(level) \(day) 테스트"
        lbEumhun.adjustsFontSizeToFitWidth = true
        lbJpSound.adjustsFontSizeToFitWidth = true
        lbJpMeaning.adjustsFontSizeToFitWidth = true
        updateKanji()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickKanji(_ sender: Any) {
        isKanjiVisible = !isKanjiVisible
        updateKanji()
    }
    
    @IBAction func onClickV(_ sender: Any) {
        testResult.append(true)
        moveOnToNextKanji()
    }
    @IBAction func onClickX(_ sender: Any) {
        testResult.append(false)
        moveOnToNextKanji()
    }
    
    private func updateKanji() {
        if index == 0 {
            btnBefore.isEnabled = false
            btnBefore.isHidden = true
        } else {
            btnBefore.isEnabled = false
            btnBefore.isHidden = true
        }
        lbIndex.text = "\(index+1)/\(kanjis.count)"
        lbKanji.text = kanjis[index].kanji
        if isKanjiVisible {
            lbHanja.text = kanjis[index].hanja
            lbEumhun.text = kanjis[index].eumhun
            lbJpSound.text = kanjis[index].jpSound
            lbJpMeaning.text = kanjis[index].jpMeaning
        } else {
            lbHanja.text = ""
            lbEumhun.text = ""
            lbJpSound.text = ""
            lbJpMeaning.text = ""
        }
    }
    private func moveOnToNextKanji() {
        index += 1
        if index == kanjis.count {
            let vc = UIViewController.getViewController(viewControllerEnum: .kanjitestresult) as! KanjiTestResultViewController
            vc.level = level
            vc.day = day
            vc.kanjiCount = kanjis.count
//            vc.wrongKanjiCount = wrongKanjis.count
//            vc.kanjisForCell = wrongKanjis.map { KanjiForCell(kanji: $0) }
            navigationController?.replaceViewController(viewController: vc, animated: true)
        } else {
            isKanjiVisible = false
            updateKanji()
        }
    }
    @IBAction func onClickBefore(_ sender: Any) {
        if index == 0 {
            return
        }
        index -= 1
        isKanjiVisible = false
        updateKanji()
    }
}
