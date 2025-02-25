//
//  TestViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.07.
//

import UIKit

class TestViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
        let sectionEnum: SectionEnum?
        let day: String
        var indices: [String]
    }
    var param: Param!
    
    private var testResult: [Bool] = []
    private var index: Int = 0
    private var isVisible: Bool = false
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var lbUpperSub1: UILabel!
    @IBOutlet weak var lbUpperSub2: UILabel!
    @IBOutlet weak var lbLowerSub: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        param.indices.shuffle()
        
        ivSection.layer.cornerRadius = 12
        lbTitle.text = param.sectionEnum?.title
        lbSubtitle.text = "\(param.indexEnum.rawValue) \(param.day) 테스트"
        ivSection.image = param.sectionEnum?.image
        
        lbMain.adjustsFontSizeToFitWidth = true
        lbUpperSub1.adjustsFontSizeToFitWidth = true
        lbUpperSub2.adjustsFontSizeToFitWidth = true
        lbLowerSub.adjustsFontSizeToFitWidth = true
        lbSub.adjustsFontSizeToFitWidth = true
        
        updateTestField()
    }
    
    private func updateTestField() {
        btnPrevious.isEnabled = !(index == 0)
        btnPrevious.isHidden = index == 0
        lbIndex.text = "\(index+1)/\(param.indices.count)"
        
        switch param.sectionEnum {
        case .kanji:
            guard let kanji = GlobalDataManager.shared.kanjis[param.indices[index]] else { return }
            
            let kanjiAttributedString = NSMutableAttributedString(string: kanji.kanji)
            kanjiAttributedString.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: kanji.kanji.count))
            lbMain.attributedText = kanjiAttributedString
            
            lbUpperSub1.text = isVisible ? kanji.jpSound : ""
            lbUpperSub2.text = isVisible ? kanji.jpMeaning : ""
            lbSub.text = isVisible ? kanji.eumhun : ""
            
            if isVisible {
                let hanjaAttributedString = NSMutableAttributedString(string: kanji.hanja)
                hanjaAttributedString.addAttribute(.languageIdentifier, value: "kr", range: NSRange(location: 0, length: kanji.hanja.count))
                lbLowerSub.attributedText = hanjaAttributedString
            } else {
                lbLowerSub.text = ""
            }
        case .vocabulary:
            guard let vocabulary = GlobalDataManager.shared.vocabularies[param.indices[index]] else { return }
            
            lbMain.text = vocabulary.word
            lbUpperSub1.text = ""
            lbUpperSub2.text = isVisible ? vocabulary.sound : ""
            lbLowerSub.text = ""
            lbSub.text = isVisible ? vocabulary.meaning : ""
        default:
            break
        }
    }
    
    private func moveOnToNext() {
        index += 1
        if param.indices.count == index {
            savePass()
            replaceToTestResultViewController()
            return
        }
        isVisible = false
        updateTestField()
    }
    
    private func savePass() {
        switch param.sectionEnum {
        case .kanji:
            var pass = UserDefaultManager.shared.passKanji
            for (i, result) in testResult.enumerated() {
                if result {
                    pass.insert(param.indices[i])
                } else {
                    pass.remove(param.indices[i])
                }
            }
            UserDefaultManager.shared.passKanji = pass
        case .vocabulary:
            var pass = UserDefaultManager.shared.passVoca
            for (i, result) in testResult.enumerated() {
                if result {
                    pass.insert(param.indices[i])
                } else {
                    pass.remove(param.indices[i])
                }
            }
            UserDefaultManager.shared.passVoca = pass
        default:
             return
        }
    }
    
    private func replaceToTestResultViewController() {
        let vc = UIViewController.getViewController(viewControllerEnum: .testresult) as! TestResultViewController
        vc.param = TestResultViewController.Param(
            indexEnum: param.indexEnum,
            sectionEnum: param.sectionEnum,
            day: param.day,
            allCount: param.indices.count,
            indices: testResult.enumerated().compactMap({ (i, result) in
                result ? nil : param.indices[i]
            })
        )
        navigationController?.replaceViewController(viewController: vc, animated: true)
    }
    
    private func moveOnToPrevious() {
        if index == 0 {
            return
        }
        index -= 1
        testResult.removeLast()
        isVisible = false
        updateTestField()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickX(_ sender: Any) {
        testResult.append(false)
        moveOnToNext()
    }
    
    @IBAction func onClickV(_ sender: Any) {
        testResult.append(true)
        moveOnToNext()
    }
    @IBAction func onClickPrevious(_ sender: Any) {
        moveOnToPrevious()
    }
    @IBAction func onClickTestField(_ sender: Any) {
        isVisible = !isVisible
        updateTestField()
    }
}
