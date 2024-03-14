//
//  VocabularyTestViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/11/24.
//

import UIKit

class VocabularyTestViewController: UIViewController {
    var vocabularies: [Vocabulary] = []
    var level: String = ""
    
    private var wrongVocabularies: [Vocabulary] = []
    private var index: Int = 0
    private var isVocabularyVisible: Bool = false
    
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var lbWord: UILabel!
    @IBOutlet weak var lbSound: UILabel!
    @IBOutlet weak var lbMeaning: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocabularies.shuffle()
        lbLevel.text = "\(level) 테스트"
        updateVocabulary()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickVocabulary(_ sender: Any) {
        isVocabularyVisible = !isVocabularyVisible
        updateVocabulary()
    }
    
    @IBAction func onClickV(_ sender: Any) {
        moveOnToNextVocabulary()
    }
    @IBAction func onClickX(_ sender: Any) {
        wrongVocabularies.append(vocabularies[index])
        moveOnToNextVocabulary()
    }
    
    private func updateVocabulary() {
        lbIndex.text = "\(index+1)/\(vocabularies.count)"
        lbWord.text = vocabularies[index].word
        if isVocabularyVisible {
            lbSound.text = vocabularies[index].sound
            lbMeaning.text = vocabularies[index].meaning
        } else {
            lbSound.text = ""
            lbMeaning.text = ""
        }
    }
    private func moveOnToNextVocabulary() {
        index += 1
        if index == vocabularies.count {
            let vc = UIViewController.getViewController(viewControllerEnum: .vocabularytestresult) as! VocabularyTestResultViewController
            vc.level = level
            vc.vocaCount = vocabularies.count
            vc.wrongVocaCount = wrongVocabularies.count
            vc.vocabulariesForCell = wrongVocabularies.map { VocabularyForCell(vocabulary: $0) }
            navigationController?.replaceViewController(viewController: vc, animated: true)
        } else {
            isVocabularyVisible = false
            updateVocabulary()
        }
    }
}
