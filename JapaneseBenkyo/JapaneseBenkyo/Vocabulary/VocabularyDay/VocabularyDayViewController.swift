//
//  VocabularyDayViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/8/24.
//

import UIKit
import Foundation

class VocabularyDayViewController: UIViewController {

    var vocabularies: [Vocabulary] = []
    var level: String = ""
    
    private var vocabulariesDayDistributed: [Array<Vocabulary>] = []
    private var process: [String: [String: Bool]] = [:]
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocabulariesDayDistributed = stride(from: 0, to: vocabularies.count, by: CommonConstant.daySize).map {
            Array(vocabularies[$0..<min($0 + CommonConstant.daySize, vocabularies.count)])
        }
        lbTitle.text = level
        
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

extension VocabularyDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulariesDayDistributed.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! IndexTableViewCell
        }
//        cell.ivIcon.image = UIImage(named: "hiragana.png")
        if indexPath.row == 0 {
            cell.lbTitle.text = "전체보기"
        } else {
            cell.lbTitle.text = "Day\(indexPath.row)"
        }
        if process[level]?[cell.lbTitle.text ?? ""] ?? false {
            cell.ivProcess.image = UIImage(systemName: "checkmark.circle")
            cell.ivProcess.tintColor = .systemGreen
        } else {
            cell.ivProcess.image = UIImage(systemName: "circle")
            cell.ivProcess.tintColor = .systemGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
        
        if indexPath.row == 0 {
            vc.level = level
            vc.day = "전체보기"
            vc.vocabulariesForCell = vocabularies.map { VocabularyForCell(vocabulary: $0) }
        } else {
            vc.level = level
            vc.day = "Day\(indexPath.row)"
            vc.vocabulariesForCell = vocabulariesDayDistributed[indexPath.row-1].map { VocabularyForCell(vocabulary: $0) }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
