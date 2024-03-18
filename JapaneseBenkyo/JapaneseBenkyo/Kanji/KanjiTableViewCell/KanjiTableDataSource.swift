//
//  KanjiTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/16/24.
//

import UIKit

class KanjiTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var kanjisForCell: [KanjiForCell]
    private var bookmark: Set<Kanji> = []
    
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
        for kanjiForCell in kanjisForCell {
            kanjiForCell.isVisibleEumhun = true
            kanjiForCell.isVisibleJpSound = true
            kanjiForCell.isVisibleJpMeaning = true
        }
    }
    
    func setInvisibleAll() {
        for kanjiForCell in kanjisForCell {
            kanjiForCell.isVisibleEumhun = false
            kanjiForCell.isVisibleJpSound = false
            kanjiForCell.isVisibleJpMeaning = false
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
        
        cell.onClickHanja = { [weak self] sender in
            self?.onClickHanja(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickEumhun = { [weak self] sender in
            self?.onClickEumhun(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickJpSound = { [weak self] sender in
            self?.onClickJpSound(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickJpMeaning = { [weak self] sender in
            self?.onClickJpMeaning(cell, sender, kanjiForCell: kanjiForCell)
        }
        cell.onClickBookmark = { [weak self] sender in
            self?.onClickBookmark(cell, sender, kanjiForCell: kanjiForCell)
        }
        
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? KanjiTableViewCell {
            if (kanjisForCell[indexPath.row].isVisibleHanja || kanjisForCell[indexPath.row].kanji.hanja == "") && kanjisForCell[indexPath.row].isVisibleEumhun && kanjisForCell[indexPath.row].isVisibleJpSound && kanjisForCell[indexPath.row].isVisibleJpMeaning {
                kanjisForCell[indexPath.row].isVisibleEumhun = false
                kanjisForCell[indexPath.row].isVisibleJpSound = false
                kanjisForCell[indexPath.row].isVisibleJpMeaning = false
            } else {
                kanjisForCell[indexPath.row].isVisibleEumhun = true
                kanjisForCell[indexPath.row].isVisibleJpSound = true
                kanjisForCell[indexPath.row].isVisibleJpMeaning = true
            }
            initializeCell(cell: cell, kanjiForCell: kanjisForCell[indexPath.row])
        }
    }
    
    private func onClickHanja(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        kanjiForCell.isVisibleHanja = !kanjiForCell.isVisibleHanja
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
    }
    private func onClickEumhun(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        kanjiForCell.isVisibleEumhun = !kanjiForCell.isVisibleEumhun
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
    }
    private func onClickJpSound(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        kanjiForCell.isVisibleJpSound = !kanjiForCell.isVisibleJpSound
        initializeCell(cell: cell, kanjiForCell: kanjiForCell)
    }
    private func onClickJpMeaning(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell) {
        kanjiForCell.isVisibleJpMeaning = !kanjiForCell.isVisibleJpMeaning
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
    
    private func initializeCell(cell: KanjiTableViewCell, kanjiForCell: KanjiForCell) {
        if kanjiForCell.kanji.hanja == "" {
            cell.lbKanji.text = kanjiForCell.kanji.kanji
            cell.btnHanja.tintColor = .clear
        } else {
            if kanjiForCell.isVisibleHanja {
                cell.lbKanji.text = kanjiForCell.kanji.hanja
                cell.btnHanja.setTitle("日 한자 보기", for: .normal)
                cell.btnHanja.tintColor = .lightGray
            } else {
                cell.lbKanji.text = kanjiForCell.kanji.kanji
                cell.btnHanja.setTitle("韓 한자 보기", for: .normal)
                cell.btnHanja.tintColor = .lightGray
            }
        }
        if kanjiForCell.isVisibleEumhun {
            cell.lbEumhun.text = kanjiForCell.kanji.eumhun
            cell.btnEumhun.tintColor = .clear
        } else {
            cell.lbEumhun.text = ""
            cell.btnEumhun.tintColor = .lightGray
        }
        if kanjiForCell.isVisibleJpSound {
            cell.lbJpSound.text = kanjiForCell.kanji.jpSound
            cell.btnJpSound.tintColor = .clear
        } else {
            cell.lbJpSound.text = ""
            cell.btnJpSound.tintColor = .lightGray
        }
        if kanjiForCell.isVisibleJpMeaning {
            cell.lbJpMeaning.text = kanjiForCell.kanji.jpMeaning
            cell.btnJpMeaning.tintColor = .clear
        } else {
            cell.lbJpMeaning.text = ""
            cell.btnJpMeaning.tintColor = .lightGray
        }
        if kanjiForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
