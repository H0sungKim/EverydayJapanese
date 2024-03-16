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
    
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbSubScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vocabularyTableDataSource = VocabularyTableDataSource(vocabulariesForCell: vocabulariesForCell)
        
        tableView.delegate = vocabularyTableDataSource
        tableView.dataSource = vocabularyTableDataSource
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))
        
        lbLevel.text = "\(level) \(day) 테스트 결과"
        lbScore.text = "\(Int((vocaCount! - wrongVocaCount!) * 100 / vocaCount!))점"
        lbSubScore.text = "\(vocaCount! - wrongVocaCount!)/\(vocaCount!)"
        
        if wrongVocaCount == 0 {
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
        if vc.vocabularies.count > 0 {
            navigationController?.replaceViewController(viewController: vc, animated: true)
        } else {
            sender.isEnabled = false
        }
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
