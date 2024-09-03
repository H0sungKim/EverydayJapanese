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
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isVisibleSound = true
            vocabularyForCell.isVisibleMeaning = true
        }
    }
    
    func setInvisibleAll() {
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isVisibleSound = false
            vocabularyForCell.isVisibleMeaning = false
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
        
        cell.onClickSound = { [weak self] sender in
            self?.onClickSound(cell, sender, vocabularyForCell: vocabularyForCell)
        }
        cell.onClickMeaning = { [weak self] sender in
            self?.onClickMeaning(cell, sender, vocabularyForCell: vocabularyForCell)
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
            if (vocabulariesForCell[indexPath.row].isVisibleSound || vocabulariesForCell[indexPath.row].vocabulary.sound == "") && vocabulariesForCell[indexPath.row].isVisibleMeaning {
                vocabulariesForCell[indexPath.row].isVisibleSound = false
                vocabulariesForCell[indexPath.row].isVisibleMeaning = false
            } else {
                vocabulariesForCell[indexPath.row].isVisibleSound = true
                vocabulariesForCell[indexPath.row].isVisibleMeaning = true
            }
            initializeCell(cell: cell, vocabularyForCell: vocabulariesForCell[indexPath.row])
        }
    }
    
    private func onClickSound(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        vocabularyForCell.isVisibleSound = !vocabularyForCell.isVisibleSound
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
    }
    private func onClickMeaning(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        vocabularyForCell.isVisibleMeaning = !vocabularyForCell.isVisibleMeaning
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
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
        if vocabularyForCell.vocabulary.sound == "" {
            cell.lbSound.text = ""
        } else {
            if vocabularyForCell.isVisibleSound {
                cell.lbSound.text = vocabularyForCell.vocabulary.sound
            } else {
                cell.lbSound.text = ""
            }
        }
        if vocabularyForCell.isVisibleMeaning {
            cell.lbMeaning.text = vocabularyForCell.vocabulary.meaning
        } else {
            cell.lbMeaning.text = ""
        }
        if vocabularyForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
    }
}
