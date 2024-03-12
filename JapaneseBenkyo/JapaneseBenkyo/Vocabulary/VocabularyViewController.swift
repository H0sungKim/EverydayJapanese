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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
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
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
        }

        cell.lbTitle.text = catalogues[indexPath.row].rawValue
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
            if let jsonData = JSONManager.shared.openJSON(path: "JLPT\(6-indexPath.row)") {
                vc.vocabularies = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
