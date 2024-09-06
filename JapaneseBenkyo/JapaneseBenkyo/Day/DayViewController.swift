//
//  DayViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.06.
//

import UIKit

class DayViewController: UIViewController {
    
    var index: IndexEnum?
    
    private var process: [String: [String: Bool]] = [:]
    
    private var kanjisDayDistributed: [Array<Kanji>]?
    private var vocabulariesDayDistributed: [Array<Vocabulary>]?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var lbProcess: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSection.image = index?.getSection()?.image
        lbTitle.text = index?.getSection()?.title
        lbSubtitle.text = index?.rawValue
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        tableView.register(UINib(nibName: String(describing: Index2TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: Index2TableViewCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
        tableView.reloadData()
    }
    
    func initializeView(index: IndexEnum) {
        
        self.index = index
        
        switch index.getSection() {
        case .hiraganakatagana:
            break
        case .kanji:
            if let jsonData = JSONManager.shared.openJSON(path: index.getFileName()) {
                let kanjis: [Kanji] = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData)
                kanjisDayDistributed = stride(from: 0, to: kanjis.count, by: CommonConstant.daySize).map {
                    Array(kanjis[$0..<min($0 + CommonConstant.daySize, kanjis.count)])
                }
            }
        case .vocabulary:
            if let jsonData = JSONManager.shared.openJSON(path: index.getFileName()) {
                let vocabularies: [Vocabulary] = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData)
                vocabulariesDayDistributed = stride(from: 0, to: vocabularies.count, by: CommonConstant.daySize).map {
                    Array(vocabularies[$0..<min($0 + CommonConstant.daySize, vocabularies.count)])
                }
            }
        case .none:
            break
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (kanjisDayDistributed?.count ?? 0) + (vocabulariesDayDistributed?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Index2TableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: Index2TableViewCell.self), for: indexPath) as? Index2TableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: Index2TableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! Index2TableViewCell
        }
        let title: String = indexPath.row == 0 ? "전체보기" : "Day\(indexPath.row)"
        cell.initializeView(title: title, process: process[lbSubtitle.text ?? ""]?[title])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
        
//        navigationController?.pushViewController(vc, animated: true)
    }
}
