//
//  VocabularyTestResultViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/13/24.
//

import UIKit

class VocabularyTestResultViewController: UIViewController {

    var vocabulariesForCell: [VocabularyForCell] = []
    var level: String = ""
    var day: String = ""
    var vocaCount: Int?
    var wrongVocaCount: Int?
    
    private var vocabularyTableDataSource: VocabularyTableDataSource?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnReTest: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbSubScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vocabularyTableDataSource = VocabularyTableDataSource(vocabulariesForCell: vocabulariesForCell)
        
        tableView.delegate = vocabularyTableDataSource
        tableView.dataSource = vocabularyTableDataSource
        tableView.rowHeight = CGFloat(CommonConstant.shared.cellSize)
        tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))
        
        lbTitle.text = "\(level) \(day) 테스트 결과"
        lbScore.text = "\(Int((vocaCount! - wrongVocaCount!) * 100 / vocaCount!))점"
        lbSubScore.text = "\(vocaCount! - wrongVocaCount!)/\(vocaCount!)"
        
        if wrongVocaCount == 0 {
            btnBookmark.isEnabled = false
            btnReTest.isEnabled = false
            saveProcess()
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBookmark(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        vocabularyTableDataSource?.addBookmarkAll()
        sender.isEnabled = false
        tableView.reloadData()
    }
    @IBAction func onClickReTest(_ sender: UIButton) {
        let vc = UIViewController.getViewController(viewControllerEnum: .vocabularytest) as! VocabularyTestViewController
        vc.vocabularies = vocabulariesForCell.map { $0.vocabulary }
        vc.level = level
        vc.day = day
        navigationController?.replaceViewController(viewController: vc, animated: true)
    }
    @IBAction func onClickFinishTest(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private func saveProcess() {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            var process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
            if process[level] == nil {
                process[level] = [:]
            }
            process[level]?[day] = true
            
            UserDefaultManager.shared.process = JSONManager.shared.encodeProcessJSON(process: process)
        }
    }
}
