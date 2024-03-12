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
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let daySize = 20
        vocabulariesDayDistributed = stride(from: 0, to: vocabularies.count, by: daySize).map {
            Array(vocabularies[$0..<min($0 + daySize, vocabularies.count)])
        }
        lbTitle.text = level
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
    }
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension VocabularyDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulariesDayDistributed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
        }
        if indexPath.row == 0 {
            cell.lbTitle.text = "전체보기"
        } else {
            cell.lbTitle.text = "Day\(indexPath.row)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
        
        if indexPath.row == 0 {
            vc.level = "\(level) 전체보기"
            vc.vocabulariesForCell = vocabularies.map { VocabularyForCell(vocabulary: $0) }
        } else {
            vc.level = "\(level) Day\(indexPath.row)"
            vc.vocabulariesForCell = vocabulariesDayDistributed[indexPath.row-1].map { VocabularyForCell(vocabulary: $0) }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
