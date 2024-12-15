//
//  KanjiTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/16/24.
//

import UIKit

class KanjiTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var kanjisForCell: [KanjiForCell]
    private var bookmark: Set<Kanji> = []
    var onReload: ((_ indexPath: IndexPath)->Void)?
    
    init(kanjisForCell: [KanjiForCell]) {
        self.kanjisForCell = kanjisForCell
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
            bookmark = JSONManager.shared.decodeJSONtoKanjiSet(jsonData: jsonData)
        }
        for kanjiForCell in kanjisForCell {
            kanjiForCell.isBookmark = bookmark.contains(kanjiForCell.kanji)
        }
        super.init()
    }
    
    func shuffleKanjis() {
        kanjisForCell.shuffle()
    }
    
    func setVisibleAll() {
        // all kanjisForCell is visible
        if !kanjisForCell.contains(where: { !$0.isVisible }) {
            for kanjiForCell in kanjisForCell {
                kanjiForCell.isVisible = false
            }
        } else {
            for kanjiForCell in kanjisForCell {
                kanjiForCell.isVisible = true
            }
        }
    }
    
    func addBookmarkAll() {
        bookmark.formUnion(Set(kanjisForCell.map { $0.kanji }))
        UserDefaultManager.shared.kanjiBookmark = JSONManager.shared.encodeKanjiJSON(kanjis: bookmark)
        for kanjiForCell in kanjisForCell {
            kanjiForCell.isBookmark = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjisForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KanjiTableViewCell
        let kanjiForCell: KanjiForCell = kanjisForCell[indexPath.row]
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: KanjiTableViewCell.self), for: indexPath) as? KanjiTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: KanjiTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! KanjiTableViewCell
        }
        cell.valueChangedHanja = { [weak self] sender in
            self?.valueChangedHanja(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickBookmark = { [weak self] sender in
            self?.onClickBookmark(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickPronounce = { [weak self] sender in
            self?.onClickPronounce(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickExpand = { [weak self] sender in
            self?.onClickExpand(cell, sender, kanjiForCell: kanjiForCell, indexPath: indexPath)
        }
        
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? KanjiTableViewCell else {
            return
        }
        kanjisForCell[indexPath.row].isVisible = !kanjisForCell[indexPath.row].isVisible
        initializeCell(cell: cell, kanjiForCell: kanjisForCell[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func valueChangedHanja(_ cell: KanjiTableViewCell, _ sender: UISegmentedControl, kanjiForCell: KanjiForCell) {
        kanjiForCell.isVisibleHanja = sender.selectedSegmentIndex == 1
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
    }
    private func onClickBookmark(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        if kanjiForCell.isBookmark {
            bookmark.remove(kanjiForCell.kanji)
        } else {
            bookmark.insert(kanjiForCell.kanji)
        }
        kanjiForCell.isBookmark = !kanjiForCell.isBookmark
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
        UserDefaultManager.shared.kanjiBookmark = JSONManager.shared.encodeKanjiJSON(kanjis: bookmark)
    }
    private func onClickPronounce(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        TTSManager.shared.play(kanji: kanjiForCell.kanji)
    }
    private func onClickExpand(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell, indexPath: IndexPath) {
        kanjiForCell.isExpanded = !kanjiForCell.isExpanded
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
        onReload?(indexPath)
    }
    
    private func initializeCell(cell: KanjiTableViewCell, kanjiForCell: KanjiForCell) {
        cell.scHanja.isHidden = kanjiForCell.kanji.hanja == ""
        let attributedString = NSMutableAttributedString(string: kanjiForCell.isVisibleHanja ? kanjiForCell.kanji.hanja : kanjiForCell.kanji.kanji)
        attributedString.addAttribute(.languageIdentifier, value: kanjiForCell.isVisibleHanja ? "kr" : "ja", range: NSRange(location: 0, length: kanjiForCell.isVisibleHanja ? kanjiForCell.kanji.hanja.count : kanjiForCell.kanji.kanji.count))
        cell.lbKanji.attributedText = attributedString
        cell.scHanja.selectedSegmentIndex = kanjiForCell.isVisibleHanja ? 1 : 0
        
        cell.lbEumhun.text = kanjiForCell.isVisible ? kanjiForCell.kanji.eumhun : ""
        cell.lbJpSound.text = kanjiForCell.isVisible ? kanjiForCell.kanji.jpSound : ""
        cell.lbJpMeaning.text = kanjiForCell.isVisible ? kanjiForCell.kanji.jpMeaning : ""
        
        cell.btnBookmark.setImage(UIImage(systemName: kanjiForCell.isBookmark ? "star.fill" : "star"), for: .normal)
        
        cell.btnExpand.setImage(UIImage(systemName: kanjiForCell.isExpanded ? "chevron.up" : "chevron.down"), for: .normal)
        cell.stackView.clearSubViews()
        if kanjiForCell.isExpanded {
            expandExamples(cell: cell, kanjiForCell: kanjiForCell)
        }
    }
    
    private func expandExamples(cell: KanjiTableViewCell, kanjiForCell: KanjiForCell) {
        for example in kanjiForCell.kanji.examples {
            guard let expandableAreaView = Bundle.main.loadNibNamed(String(describing: ExampleWordView.self), owner: nil, options: nil)?.first as? ExampleWordView else {
                continue
            }
            cell.stackView.addArrangedSubview(expandableAreaView)
            let wordString = NSMutableAttributedString(string: example.word)
            wordString.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: example.word.count))
            expandableAreaView.lbWord.attributedText = wordString
            expandableAreaView.lbSound.text = example.sound
            expandableAreaView.lbMeaning.text = example.meaning
        }
    }
}
