//
//  KanjiViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import UIKit

class KanjiViewController: UIViewController {
    
    private enum LevelEnum: String, CaseIterable {
        case kanjiBookmark = "★ 즐겨찾기"
        case kanji0 = "소학교 1학년"
        case kanji1 = "소학교 2학년"
        case kanji2 = "소학교 3학년"
        case kanji3 = "소학교 4학년"
        case kanji4 = "소학교 5학년"
        case kanji5 = "소학교 6학년"
        case kanji6 = "중학교"
    }

    private let catalogues: [LevelEnum] = LevelEnum.allCases
    private var process: [String: [String: Bool]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: IndexTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IndexTableViewCell.self))
    }
    override func viewWillAppear(_ animated: Bool) {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
        tableView.reloadData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension KanjiViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! IndexTableViewCell
        }
//        cell.ivIcon.image = UIImage(named: "kanji.png")
        cell.lbTitle.text = catalogues[indexPath.row].rawValue
        
        switch catalogues[indexPath.row] {
        case .kanjiBookmark :
            cell.ivProcess.image = nil
        case .kanji0, .kanji1, .kanji2, .kanji3, .kanji4, .kanji5, .kanji6 :
            if process[catalogues[indexPath.row].rawValue]?["전체보기"] ?? false {
                cell.ivProcess.image = UIImage(systemName: "checkmark.circle")
                cell.ivProcess.tintColor = .systemGreen
            } else {
                cell.ivProcess.image = UIImage(systemName: "circle")
                cell.ivProcess.tintColor = .systemGray
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch catalogues[indexPath.row] {
            
        case .kanjiBookmark :
            let vc = UIViewController.getViewController(viewControllerEnum: .kanjistudy) as! KanjiStudyViewController
            vc.level = catalogues[indexPath.row].rawValue
            if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
                vc.kanjisForCell = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData).map { KanjiForCell(kanji: $0) }
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .kanji0, .kanji1, .kanji2, .kanji3, .kanji4, .kanji5, .kanji6 :
            let vc = UIViewController.getViewController(viewControllerEnum: .kanjiday) as! KanjiDayViewController
            vc.level = catalogues[indexPath.row].rawValue
            if let jsonData = JSONManager.shared.openJSON(path: "kanji\(indexPath.row)") {
                vc.kanjis = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
