//
//  VocabularyStudyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/15/24.
//

import UIKit

class VocabularyStudyViewController: UIViewController {

    var vocabulariesForCell: [VocabularyForCell] = []
    var level: String = ""
    
    private var vocabularyTableDataSource: VocabularyTableDataSource?
    
    private var isVisibleAll: Bool = false
    
    @IBOutlet weak var lbDifficulty: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbDifficulty.text = level
        
        vocabularyTableDataSource = VocabularyTableDataSource(vocabulariesForCell: vocabulariesForCell)
        
        tableView.delegate = vocabularyTableDataSource
        tableView.dataSource = vocabularyTableDataSource
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))

    }
    
    @IBAction func onClickVisibleAll(_ sender: UIButton) {
        if isVisibleAll {
            vocabularyTableDataSource?.setInvisibleAll()
        } else {
            vocabularyTableDataSource?.setVisibleAll()
        }
        isVisibleAll = !isVisibleAll
        tableView.reloadData()
    }
    
    @IBAction func onClickShuffle(_ sender: Any) {
        vocabularyTableDataSource?.shuffleVocabularies()
        tableView.reloadData()
    }
    
    @IBAction func onClickTest(_ sender: Any) {
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularytest)
        navigationController?.pushViewController(vc, animated: true)
    }
}
