//
//  StudyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit

class KanjiStudyViewController: UIViewController {
    
    var kanjisForCell: [KanjiForCell] = []
    var level: String = ""
    var day: String = ""
    
    private var kanjiTableDataSource: KanjiTableDataSource?
    
    private var isVisibleAll: Bool = false
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbTitle.text = "\(level) \(day)"
        
        kanjiTableDataSource = KanjiTableDataSource(kanjisForCell: kanjisForCell)
        tableView.delegate = kanjiTableDataSource
        tableView.dataSource = kanjiTableDataSource
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: String(describing: KanjiTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: KanjiTableViewCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kanjiTableDataSource = KanjiTableDataSource(kanjisForCell: kanjisForCell)
        tableView.delegate = kanjiTableDataSource
        tableView.dataSource = kanjiTableDataSource
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickVisibleAll(_ sender: UIButton) {
        if isVisibleAll {
            kanjiTableDataSource?.setInvisibleAll()
        } else {
            kanjiTableDataSource?.setVisibleAll()
        }
        isVisibleAll = !isVisibleAll
        tableView.reloadData()
    }
    
    @IBAction func onClickShuffle(_ sender: Any) {
        kanjiTableDataSource?.shuffleKanjis()
        tableView.reloadData()
    }
    
    @IBAction func onClickTest(_ sender: UIButton) {
        let vc = UIViewController.getViewController(viewControllerEnum: .kanjitest) as! KanjiTestViewController
        vc.kanjis = kanjisForCell.map { $0.kanji }
        vc.level = level
        vc.day = day
        if vc.kanjis.count > 0 {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            sender.isEnabled = false
        }
    }
}
