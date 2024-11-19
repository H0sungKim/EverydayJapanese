//
//  VocabularyTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/11/24.
//

import UIKit

class VocabularyTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var vocabulariesForCell: [VocabularyForCell]
    private var bookmark: Set<Vocabulary> = []
    
    init(vocabulariesForCell: [VocabularyForCell]) {
        self.vocabulariesForCell = vocabulariesForCell
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
            bookmark = JSONManager.shared.decodeJSONtoVocabularySet(jsonData: jsonData)
        }
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isBookmark = bookmark.contains(vocabularyForCell.vocabulary)
        }
        super.init()
    }
    
    func shuffleVocabularies() {
        vocabulariesForCell.shuffle()
    }
    
    func setVisibleAll() {
        // all vocabulariesForCell is visible
        if !vocabulariesForCell.contains(where: { !$0.isVisible }) {
            for vocabularyForCell in vocabulariesForCell {
                vocabularyForCell.isVisible = false
            }
        } else {
            for vocabularyForCell in vocabulariesForCell {
                vocabularyForCell.isVisible = true
            }
        }
    }
    
    func addBookmarkAll() {
        bookmark.formUnion(Set(vocabulariesForCell.map { $0.vocabulary }))
        UserDefaultManager.shared.vocabularyBookmark = JSONManager.shared.encodeVocabularyJSON(vocabularies: bookmark)
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isBookmark = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulariesForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VocabularyTableViewCell
        let vocabularyForCell: VocabularyForCell = vocabulariesForCell[indexPath.row]
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: VocabularyTableViewCell.self), for: indexPath) as? VocabularyTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: VocabularyTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! VocabularyTableViewCell
        }
        
        cell.onClickBookmark = { [weak self] sender in
            self?.onClickBookmark(cell, sender, vocabularyForCell: vocabularyForCell)
        }
        cell.onClickPronounce = { [weak self] sender in
            self?.onClickPronounce(cell, sender, vocabularyForCell: vocabularyForCell)
        }
        
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? VocabularyTableViewCell {
            vocabulariesForCell[indexPath.row].isVisible = !vocabulariesForCell[indexPath.row].isVisible
            initializeCell(cell: cell, vocabularyForCell: vocabulariesForCell[indexPath.row])
        }
    }
    
    private func onClickBookmark(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isBookmark {
            bookmark.remove(vocabularyForCell.vocabulary)
        } else {
            bookmark.insert(vocabularyForCell.vocabulary)
        }
        vocabularyForCell.isBookmark = !vocabularyForCell.isBookmark
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        UserDefaultManager.shared.vocabularyBookmark = JSONManager.shared.encodeVocabularyJSON(vocabularies: bookmark)
    }
    private func onClickPronounce(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        TTSManager.shared.play(vocabulary: vocabularyForCell.vocabulary)
    }
    
    private func initializeCell(cell: VocabularyTableViewCell, vocabularyForCell: VocabularyForCell) {
        cell.lbWord.text = vocabularyForCell.vocabulary.word
        if vocabularyForCell.isVisible {
            cell.lbSound.text = vocabularyForCell.vocabulary.sound
            cell.lbMeaning.text = vocabularyForCell.vocabulary.meaning
        } else {
            cell.lbSound.text = ""
            cell.lbMeaning.text = ""
        }
        if vocabularyForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
