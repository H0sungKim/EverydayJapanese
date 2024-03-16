//
//  KanjiDayViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/8/24.
//

import UIKit

class KanjiDayViewController: UIViewController {

    var kanjis: [Kanji] = []
    var level: String = ""
    
    private var kanjisDayDistributed: [Array<Kanji>] = []
    private var process: [String: [String: Bool]] = [:]
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kanjisDayDistributed = stride(from: 0, to: kanjis.count, by: CommonConstant.shared.daySize).map {
            Array(kanjis[$0..<min($0 + CommonConstant.shared.daySize, kanjis.count)])
        }
        lbTitle.text = level
        
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
    }
    override func viewDidAppear(_ animated: Bool) {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
        tableView.reloadData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension KanjiDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjisDayDistributed.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
        }
        cell.ivIcon.image = UIImage(named: "kanji.png")
        if indexPath.row == 0 {
            cell.lbTitle.text = "전체보기"
            cell.lbSubtitle.text = ""
        } else {
            cell.lbTitle.text = "Day\(indexPath.row)"
            cell.lbSubtitle.text = kanjisDayDistributed[indexPath.row-1].map { KanjiForCell(kanji: $0).kanji.kanji }.joined()
        }
        if process[level]?[cell.lbTitle.text ?? ""] ?? false {
            cell.ivProcess.image = UIImage(systemName: "checkmark.circle")
            cell.ivProcess.tintColor = .systemBlue
        } else {
            cell.ivProcess.image = UIImage(systemName: "circle")
            cell.ivProcess.tintColor = .systemGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .kanjistudy) as! KanjiStudyViewController
        
        if indexPath.row == 0 {
            vc.level = level
            vc.day = "전체보기"
            vc.kanjisForCell = kanjis.map { KanjiForCell(kanji: $0) }
        } else {
            vc.level = level
            vc.day = "Day\(indexPath.row)"
            vc.kanjisForCell = kanjisDayDistributed[indexPath.row-1].map { KanjiForCell(kanji: $0) }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
