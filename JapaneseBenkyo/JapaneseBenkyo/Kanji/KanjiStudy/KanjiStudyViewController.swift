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
    
    private var kanjiTableDataSource: KanjiTableViewHandler?
    
    private var isVisibleAll: Bool = false
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbTitle.text = "\(level) \(day)"
        
        tableView.register(UINib(nibName: String(describing: KanjiTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: KanjiTableViewCell.self))
        
        if kanjisForCell.count == 0 {
            btnTest.isEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kanjiTableDataSource = KanjiTableViewHandler(kanjisForCell: kanjisForCell, tableView: tableView)
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
        navigationController?.pushViewController(vc, animated: true)
    }
}
