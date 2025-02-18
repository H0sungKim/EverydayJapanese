//
//  VocabularyTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/11/24.
//

import UIKit
import Combine
import SkeletonView

class VocabularyTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var vocabulariesForCell: [VocabularyForCell] = []
    private var bookmark: Set<String> = UserDefaultManager.shared.bookmarkVoca
    private var pass: Set<String> = UserDefaultManager.shared.passVoca
    var onReload: ((_ indexPath: IndexPath)->Void)?
    var showSkeleton: ((_ indexPath: IndexPath)->Void)?
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(indices: [String]) {
        let vocabularies = GlobalDataManager.shared.vocabularies
        super.init()
        vocabulariesForCell = indices.compactMap({ [weak self] index in
            guard let self = self, let vocabulary = vocabularies[index] else { return nil }
            return VocabularyForCell(id: index, vocabulary: vocabulary, isBookmark: bookmark.contains(index))
        })
    }
    
    func shuffleVocabularies() {
        vocabulariesForCell.shuffle()
    }
    
    func setVisibleAll() {
        let hasInvisible: Bool = vocabulariesForCell.contains(where: { !$0.isVisible })
        
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isVisible = hasInvisible
        }
    }
    
    func addBookmarkAll() {
        bookmark.formUnion(Set(vocabulariesForCell.map { $0.id }))
        UserDefaultManager.shared.bookmarkVoca = bookmark
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
        cell.onClickExpand = { [weak self] sender in
            self?.onClickExpand(cell, sender, vocabularyForCell: vocabularyForCell, indexPath: indexPath)
        }
        cell.onClickReload = { [weak self] in
            self?.onClickReload(cell, vocabularyForCell: vocabularyForCell, indexPath: indexPath)
        }
        
        cell.initializeCell(vocabularyForCell: vocabularyForCell)
        
//        if pass.contains(vocabularyForCell.id) {
//            cell.ivPass.image = UIImage(systemName: "checkmark.circle")
//            cell.ivPass.tintColor = .systemGreen
//        } else {
//            cell.ivPass.image = UIImage(systemName: "circle")
//            cell.ivPass.tintColor = .systemGray
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? VocabularyTableViewCell else { return }
        vocabulariesForCell[indexPath.row].isVisible = !vocabulariesForCell[indexPath.row].isVisible
        cell.initializeCell(vocabularyForCell: vocabulariesForCell[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func onClickBookmark(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isBookmark {
            bookmark.remove(vocabularyForCell.id)
        } else {
            bookmark.insert(vocabularyForCell.id)
        }
        vocabularyForCell.isBookmark = !vocabularyForCell.isBookmark
        cell.initializeCell(vocabularyForCell: vocabularyForCell)
        UserDefaultManager.shared.bookmarkVoca = bookmark
    }
    private func onClickPronounce(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        TTSManager.shared.play(vocabulary: vocabularyForCell.vocabulary)
    }
    private func onClickExpand(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell, indexPath: IndexPath) {
        vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
        cell.initializeCell(vocabularyForCell: vocabularyForCell)
        onReload?(indexPath)
        if let _ = vocabularyForCell.exampleSentence {
            return
        }
        CommonRepository.shared.getSentence(word: vocabularyForCell.vocabulary.word)
            .sink(receiveCompletion: { error in
                NSLog("\(error)")
            }, receiveValue: { [weak self] tatoebaModel in
                print(tatoebaModel)
                vocabularyForCell.exampleSentence = tatoebaModel
                cell.initializeCell(vocabularyForCell: vocabularyForCell)
                self?.onReload?(indexPath)
            })
            .store(in: &cancellable)
    }
    
    private func onClickReload(_ cell: VocabularyTableViewCell, vocabularyForCell: VocabularyForCell, indexPath: IndexPath) {
        guard let hasNext = vocabularyForCell.exampleSentence?.hasNext else { return }
        if !hasNext { return }
        CommonRepository.shared.getSentence(word: vocabularyForCell.vocabulary.word, cursor_end: vocabularyForCell.exampleSentence?.cursor_end)
            .sink(receiveCompletion: { error in
                NSLog("\(error)")
            }, receiveValue: { [weak self] tatoebaModel in
                print(tatoebaModel)
                vocabularyForCell.exampleSentence = tatoebaModel
                cell.initializeCell(vocabularyForCell: vocabularyForCell)
                self?.onReload?(indexPath)
            })
            .store(in: &cancellable)
    }
    
    func reload() {
        bookmark = UserDefaultManager.shared.bookmarkVoca
        pass = UserDefaultManager.shared.passVoca
    }
}
