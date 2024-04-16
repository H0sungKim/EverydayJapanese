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
    var day: String = ""
    
    private var vocabularyTableDataSource: VocabularyTableDataSource?
    
    private var isVisibleAll: Bool = false
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.text = "\(level) \(day)"
        
        tableView.rowHeight = CGFloat(CommonConstant.cellSize)
        tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))
        
        if vocabulariesForCell.count == 0 {
            btnTest.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vocabularyTableDataSource = VocabularyTableDataSource(vocabulariesForCell: vocabulariesForCell)
        tableView.delegate = vocabularyTableDataSource
        tableView.dataSource = vocabularyTableDataSource
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    @IBAction func onClickTest(_ sender: UIButton) {
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularytest) as! VocabularyTestViewController
        vc.vocabularies = vocabulariesForCell.map { $0.vocabulary }
        vc.level = level
        vc.day = day
        navigationController?.pushViewController(vc, animated: true)
    }
}
