//
//  StudyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit

class KanjiStudyViewController: UIViewController {
    
    var kanjisForCell: [KanjiForCell] = []
    var bookmark: Set<Kanji> = []
    var difficulty: String = ""
    @IBOutlet weak var lbDifficulty: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbDifficulty.text = difficulty
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: String(describing: KanjiTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: KanjiTableViewCell.self))
        
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
            bookmark = JSONManager.shared.decodeJSONtoKanjiSet(jsonData: jsonData)
        }
        for kanjiForCell in kanjisForCell {
            kanjiForCell.isBookmark = bookmark.contains(kanjiForCell.kanji)
        }
    }
    @IBAction func onClickShuffle(_ sender: Any) {
        kanjisForCell.shuffle()
        tableView.reloadData()
    }
}

extension KanjiStudyViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    private func onClickHanja(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell?) {
        sender.setTitle("", for: .normal)
        cell.lbHanja.text = kanjiForCell?.kanji.hanja
        kanjiForCell?.isVisibleHanja = true
    }
    private func onClickEumhun(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell?) {
        sender.setTitle(kanjiForCell?.kanji.eumhun, for: .normal)
        sender.setTitleColor(.label, for: .normal)
        kanjiForCell?.isVisibleEumhun = true
    }
    private func onClickJpSound(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell?) {
        sender.setTitle("音 ⇒ " + (kanjiForCell?.kanji.jpSound ?? ""), for: .normal)
        sender.setTitleColor(.label, for: .normal)
        kanjiForCell?.isVisibleJpSound = true
    }
    private func onClickJpMeaning(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell?) {
        sender.setTitle("訓 ⇒ " + (kanjiForCell?.kanji.jpMeaning ?? ""), for: .normal)
        sender.setTitleColor(.label, for: .normal)
        kanjiForCell?.isVisibleJpMeaning = true
    }
    private func onClickBookmark(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell?) {
        if kanjiForCell!.isBookmark {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            kanjiForCell?.isBookmark = false
            bookmark.remove(kanjiForCell!.kanji)
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            kanjiForCell?.isBookmark = true
            bookmark.insert(kanjiForCell!.kanji)
        }
        UserDefaultManager.shared.kanjiBookmark = JSONManager.shared.encodeKanjiJSON(kanjis: bookmark)
    }
    
    private func initializeCell(cell: KanjiTableViewCell, kanjiForCell: KanjiForCell) {
        cell.lbKanji.text = kanjiForCell.kanji.kanji
        if kanjiForCell.kanji.hanja == "" {
            cell.lbHanja.text = ""
            cell.btnHanja.setTitle("", for: .normal)
            cell.btnHanja.isEnabled = false
        } else {
            if kanjiForCell.isVisibleHanja {
                cell.lbHanja.text = kanjiForCell.kanji.hanja
                cell.btnHanja.setTitle("", for: .normal)
            } else {
                cell.lbHanja.text = ""
                cell.btnHanja.setTitle("한자 보기", for: .normal)
                cell.btnHanja.isEnabled = true
            }
        }
        if kanjiForCell.isVisibleEumhun {
            cell.btnEumhun.setTitle(kanjiForCell.kanji.eumhun, for: .normal)
            cell.btnEumhun.setTitleColor(.label, for: .normal)
        } else {
            cell.btnEumhun.setTitle("韓 훈음 보기", for: .normal)
            cell.btnEumhun.setTitleColor(.lightGray, for: .normal)
        }
        if kanjiForCell.isVisibleJpSound {
            cell.btnJpSound.setTitle(kanjiForCell.kanji.jpSound, for: .normal)
            cell.btnJpSound.setTitleColor(.label, for: .normal)
        } else {
            cell.btnJpSound.setTitle("日 음 보기", for: .normal)
            cell.btnJpSound.setTitleColor(.lightGray, for: .normal)
        }
        if kanjiForCell.isVisibleJpMeaning {
            cell.btnJpMeaning.setTitle(kanjiForCell.kanji.jpMeaning, for: .normal)
            cell.btnJpMeaning.setTitleColor(.label, for: .normal)
        } else {
            cell.btnJpMeaning.setTitle("日 훈 보기", for: .normal)
            cell.btnJpMeaning.setTitleColor(.lightGray, for: .normal)
        }
        if kanjiForCell.isBookmark {
            cell.btnBookmark.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.btnBookmark.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    
}
