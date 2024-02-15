//
//  VocabularyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import UIKit

class VocabularyViewController: UIViewController {
    
    private enum DifficultyEnum: String, CaseIterable {
        case vocabularyBookmark = "日本語の単語帳 즐겨찾기"
        case vocabulary0 = "日本語の単語帳 JLPT5"
        case vocabulary1 = "日本語の単語帳 JLPT4"
        case vocabulary2 = "日本語の単語帳 JLPT3"
        case vocabulary3 = "日本語の単語帳 JLPT2"
        case vocabulary4 = "日本語の単語帳 JLPT1"
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

extension VocabularyViewController: UITableViewDataSource, UITableViewDelegate {
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

        cell.labelTitle.text = titles[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
        vc.difficulty = titles[indexPath.row].rawValue
        switch titles[indexPath.row] {
        case .vocabularyBookmark :
            if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
                vc.vocabulariesForCell = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData).map { VocabularyForCell(vocabulary: $0) }
            }
        case .vocabulary0, .vocabulary1, .vocabulary2, .vocabulary3, .vocabulary4 :
            if let jsonData = JSONManager.shared.openJSON(path: "JLPT\(6-indexPath.row)") {
                vc.vocabulariesForCell = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData).map { VocabularyForCell(vocabulary: $0) }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
