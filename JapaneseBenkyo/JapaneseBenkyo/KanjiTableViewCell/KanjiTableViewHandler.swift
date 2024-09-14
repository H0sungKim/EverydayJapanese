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
        if kanjiForCell.kanji.hanja == "" {
            let temp = NSMutableAttributedString(string: kanjiForCell.kanji.kanji)
            temp.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: kanjiForCell.kanji.kanji.count))
            cell.lbKanji.attributedText = temp
            cell.scHanja.isHidden = true
        } else {
            cell.scHanja.isHidden = false
            if kanjiForCell.isVisibleHanja {
                let temp = NSMutableAttributedString(string: kanjiForCell.kanji.hanja)
                temp.addAttribute(.languageIdentifier, value: "kr", range: NSRange(location: 0, length: kanjiForCell.kanji.kanji.count))
                cell.lbKanji.attributedText = temp
                cell.scHanja.selectedSegmentIndex = 1
            } else {
                let temp = NSMutableAttributedString(string: kanjiForCell.kanji.kanji)
                temp.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: kanjiForCell.kanji.kanji.count))
                cell.lbKanji.attributedText = temp
                cell.scHanja.selectedSegmentIndex = 0
            }
        }
        if kanjiForCell.isVisible {
            cell.lbEumhun.text = kanjiForCell.kanji.eumhun
            cell.lbJpSound.text = kanjiForCell.kanji.jpSound
            cell.lbJpMeaning.text = kanjiForCell.kanji.jpMeaning
        } else {
            cell.lbEumhun.text = ""
            cell.lbJpSound.text = ""
            cell.lbJpMeaning.text = ""
        }
        if kanjiForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
        if kanjiForCell.isExpanded {
            cell.btnExpand.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            cell.stackView.clearSubViews()
            for example in kanjiForCell.kanji.examples {
                if let expandableAreaView = Bundle.main.loadNibNamed("ExpandableAreaView", owner: nil, options: nil)?.first as? ExpandableAreaView {
                    cell.stackView.addArrangedSubview(expandableAreaView)
                    expandableAreaView.lbTitle.text = example
                }
            }
        } else {
            cell.btnExpand.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            cell.stackView.clearSubViews()
        }
    }
}
