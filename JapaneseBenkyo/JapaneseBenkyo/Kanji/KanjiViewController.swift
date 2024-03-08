//
//  KanjiViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import UIKit

class KanjiViewController: UIViewController {
    
    private enum DifficultyEnum: String, CaseIterable {
        case kanjiBookmark = "漢字 かんじ 한자 즐겨찾기"
        case kanji0 = "漢字 かんじ 한자 소학교 1학년"
        case kanji1 = "漢字 かんじ 한자 소학교 2학년"
        case kanji2 = "漢字 かんじ 한자 소학교 3학년"
        case kanji3 = "漢字 かんじ 한자 소학교 4학년"
        case kanji4 = "漢字 かんじ 한자 소학교 5학년"
        case kanji5 = "漢字 かんじ 한자 소학교 6학년"
        case kanji6 = "漢字 かんじ 한자 중학교"
    }

    private let titles: [DifficultyEnum] = DifficultyEnum.allCases
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
    }
}

extension KanjiViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
        }

        cell.lbTitle.text = titles[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .kanjistudy) as! KanjiStudyViewController
        vc.difficulty = titles[indexPath.row].rawValue
        switch titles[indexPath.row] {
        case .kanjiBookmark :
            if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
                vc.kanjisForCell = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData).map { KanjiForCell(kanji: $0) }
            }
        case .kanji0, .kanji1, .kanji2, .kanji3, .kanji4, .kanji5, .kanji6 :
            if let jsonData = JSONManager.shared.openJSON(path: "kanji\(indexPath.row)") {
                vc.kanjisForCell = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData).map { KanjiForCell(kanji: $0) }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
