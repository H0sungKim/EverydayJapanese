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
    private var bookmark: Set<String> = GroupedUserDefaultsManager.shared.bookmarkVoca
    private var pass: Set<String> = GroupedUserDefaultsManager.shared.passVoca
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
        GroupedUserDefaultsManager.shared.bookmarkVoca = bookmark
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
            self?.onClickBookmark(cell, sender, indexPath: indexPath)
        }
        cell.onClickPronounce = { [weak self] sender in
            self?.onClickPronounce(cell, sender, indexPath: indexPath)
        }
        cell.onClickExpand = { [weak self] sender in
            self?.onClickExpand(cell, sender, indexPath: indexPath)
        }
        cell.onClickReload = { [weak self] in
            self?.onClickReload(cell, indexPath: indexPath)
        }
        
        cell.initializeCell(vocabularyForCell: vocabularyForCell)
        
        cell.ivPass.tintColor = .systemGreen
        if pass.contains(vocabularyForCell.id) {
            cell.ivPass.image = UIImage(systemName: "checkmark.circle")
        } else {
            cell.ivPass.image = nil
        }
        
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
    
    private func onClickBookmark(_ cell: VocabularyTableViewCell, _ sender: UIButton, indexPath: IndexPath) {
        if vocabulariesForCell[indexPath.row].isBookmark {
            bookmark.remove(vocabulariesForCell[indexPath.row].id)
        } else {
            bookmark.insert(vocabulariesForCell[indexPath.row].id)
        }
        vocabulariesForCell[indexPath.row].isBookmark = !vocabulariesForCell[indexPath.row].isBookmark
        cell.initializeCell(vocabularyForCell: vocabulariesForCell[indexPath.row])
        GroupedUserDefaultsManager.shared.bookmarkVoca = bookmark
    }
    private func onClickPronounce(_ cell: VocabularyTableViewCell, _ sender: UIButton, indexPath: IndexPath) {
        TTSManager.shared.play(vocabulary: vocabulariesForCell[indexPath.row].vocabulary)
    }
    private func onClickExpand(_ cell: VocabularyTableViewCell, _ sender: UIButton, indexPath: IndexPath) {
        vocabulariesForCell[indexPath.row].isExpanded = !vocabulariesForCell[indexPath.row].isExpanded
        cell.initializeCell(vocabularyForCell: vocabulariesForCell[indexPath.row])
        onReload?(indexPath)
        if let _ = vocabulariesForCell[indexPath.row].exampleSentence {
            return
        }
        CommonRepository.shared.getSentence(word: vocabulariesForCell[indexPath.row].vocabulary.word, trans: .kor)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    switch error {
                    case .moyaError:
                        NSLog(error.description)
                    case .resultNil:
                        guard let self = self else { return }
                        fetchSentence(cell, indexPath: indexPath, trans: vocabulariesForCell[indexPath.row].exampleSentence?.transEnum ?? .eng)
                    }
                }
            }, receiveValue: { [weak self] tatoebaModel in
                print(tatoebaModel)
                guard let self = self else { return }
                vocabulariesForCell[indexPath.row].exampleSentence = tatoebaModel
                cell.initializeCell(vocabularyForCell: vocabulariesForCell[indexPath.row])
                onReload?(indexPath)
            })
            .store(in: &cancellable)
    }
    
    private func onClickReload(_ cell: VocabularyTableViewCell, indexPath: IndexPath) {
        guard let hasNext = vocabulariesForCell[indexPath.row].exampleSentence?.hasNext else { return }
        if !hasNext { return }
        fetchSentence(cell, indexPath: indexPath, trans: vocabulariesForCell[indexPath.row].exampleSentence?.transEnum ?? .kor)
    }
    
    private func fetchSentence(_ cell: VocabularyTableViewCell, indexPath: IndexPath, trans: TransEnum) {
        CommonRepository.shared.getSentence(word: vocabulariesForCell[indexPath.row].vocabulary.word, trans: trans, cursor_end: vocabulariesForCell[indexPath.row].exampleSentence?.cursor_end)
            .sink(receiveCompletion: { error in
                NSLog("\(error)")
            }, receiveValue: { [weak self] tatoebaModel in
                print(tatoebaModel)
                guard let self = self else { return }
                vocabulariesForCell[indexPath.row].exampleSentence = tatoebaModel
                cell.initializeCell(vocabularyForCell: vocabulariesForCell[indexPath.row])
                onReload?(indexPath)
            })
            .store(in: &cancellable)
    }
    
    func reload() {
        bookmark = GroupedUserDefaultsManager.shared.bookmarkVoca
        pass = GroupedUserDefaultsManager.shared.passVoca
    }
}
