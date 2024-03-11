//
//  VocabularyTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/11/24.
//

import UIKit

class VocabularyTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
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
        
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? VocabularyTableViewCell {
            if (vocabulariesForCell[indexPath.row].isVisibleSound || vocabulariesForCell[indexPath.row].vocabulary.sound == "") && vocabulariesForCell[indexPath.row].isVisibleMeaning {
                vocabulariesForCell[indexPath.row].isVisibleSound = false
                vocabulariesForCell[indexPath.row].isVisibleMeaning = false
                if vocabulariesForCell[indexPath.row].vocabulary.sound != "" {
                    cell.btnSound.setTitle("발음 보기", for: .normal)
                    cell.btnSound.setTitleColor(.lightGray, for: .normal)
                }
                cell.btnMeaning.setTitle("뜻 보기", for: .normal)
                cell.btnMeaning.setTitleColor(.lightGray, for: .normal)
            } else {
                vocabulariesForCell[indexPath.row].isVisibleSound = true
                vocabulariesForCell[indexPath.row].isVisibleMeaning = true
                if vocabulariesForCell[indexPath.row].vocabulary.sound != "" {
                    cell.btnSound.setTitle(vocabulariesForCell[indexPath.row].vocabulary.sound, for: .normal)
                    cell.btnSound.setTitleColor(.label, for: .normal)
                }
                cell.btnMeaning.setTitle(vocabulariesForCell[indexPath.row].vocabulary.meaning, for: .normal)
                cell.btnMeaning.setTitleColor(.label, for: .normal)
            }
        }
    }
    
    private func onClickSound(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isVisibleSound {
            sender.setTitle("발음 보기", for: .normal)
            sender.setTitleColor(.lightGray, for: .normal)
            vocabularyForCell.isVisibleSound = false
        } else {
            sender.setTitle(vocabularyForCell.vocabulary.sound, for: .normal)
            sender.setTitleColor(.label, for: .normal)
            vocabularyForCell.isVisibleSound = true
        }
    }
    private func onClickMeaning(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isVisibleMeaning {
            sender.setTitle("뜻 보기", for: .normal)
            sender.setTitleColor(.lightGray, for: .normal)
            vocabularyForCell.isVisibleMeaning = false
        } else {
            sender.setTitle(vocabularyForCell.vocabulary.meaning, for: .normal)
            sender.setTitleColor(.label, for: .normal)
            vocabularyForCell.isVisibleMeaning = true
        }
    }
    private func onClickBookmark(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isBookmark {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            vocabularyForCell.isBookmark = false
            bookmark.remove(vocabularyForCell.vocabulary)
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            vocabularyForCell.isBookmark = true
            bookmark.insert(vocabularyForCell.vocabulary)
        }
        UserDefaultManager.shared.vocabularyBookmark = JSONManager.shared.encodeVocabularyJSON(vocabularies: bookmark)
    }
    
    private func initializeCell(cell: VocabularyTableViewCell, vocabularyForCell: VocabularyForCell) {
        cell.lbWord.text = vocabularyForCell.vocabulary.word
        if vocabularyForCell.vocabulary.sound == "" {
            cell.btnSound.setTitle("", for: .normal)
        } else {
            if vocabularyForCell.isVisibleSound {
                cell.btnSound.setTitle(vocabularyForCell.vocabulary.sound, for: .normal)
                cell.btnSound.setTitleColor(.label, for: .normal)
            } else {
                cell.btnSound.setTitle("발음 보기", for: .normal)
                cell.btnSound.setTitleColor(.lightGray, for: .normal)
            }
        }
        if vocabularyForCell.isVisibleMeaning {
            cell.btnMeaning.setTitle(vocabularyForCell.vocabulary.meaning, for: .normal)
            cell.btnMeaning.setTitleColor(.label, for: .normal)
        } else {
            cell.btnMeaning.setTitle("뜻 보기", for: .normal)
            cell.btnMeaning.setTitleColor(.lightGray, for: .normal)
        }
        if vocabularyForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
    }
}
