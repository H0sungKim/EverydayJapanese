//
//  VocabularyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import UIKit

class VocabularyViewController: UIViewController {
    
    private enum LevelEnum: String, CaseIterable {
        case vocabularyBookmark = "★ 즐겨찾기"
        case vocabulary0 = "JLPT N5"
        case vocabulary1 = "JLPT N4"
        case vocabulary2 = "JLPT N3"
        case vocabulary3 = "JLPT N2"
        case vocabulary4 = "JLPT N1"
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

extension VocabularyViewController: UITableViewDataSource, UITableViewDelegate {
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
        cell.ivIcon.image = UIImage(named: "hiragana.png")
        cell.lbTitle.text = catalogues[indexPath.row].rawValue
        
        switch catalogues[indexPath.row] {
        case .vocabularyBookmark :
            cell.ivProcess.image = nil
        case .vocabulary0, .vocabulary1, .vocabulary2, .vocabulary3, .vocabulary4 :
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
            
        case .vocabularyBookmark :
            let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
            vc.level = catalogues[indexPath.row].rawValue
            if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
                vc.vocabulariesForCell = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData).map { VocabularyForCell(vocabulary: $0) }
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .vocabulary0, .vocabulary1, .vocabulary2, .vocabulary3, .vocabulary4 :
            let vc = UIViewController.getViewController(viewControllerEnum: .vocabularyday) as! VocabularyDayViewController
            vc.level = catalogues[indexPath.row].rawValue
            if let jsonData = JSONManager.shared.openJSON(path: "n\(6-indexPath.row)") {
                vc.vocabularies = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
