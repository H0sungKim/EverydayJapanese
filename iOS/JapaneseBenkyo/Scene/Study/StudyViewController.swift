//
//  StudyViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.06.
//

import UIKit

class StudyViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
        let sectionEnum: SectionEnum?
        let day: String
        let indices: [String]
    }
    var param: Param!
    
    private var vocabularyTableViewHandler: VocabularyTableViewHandler?
    private var kanjiTableViewHandler: KanjiTableViewHandler?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    private func initializeView() {
        lbTitle.text = param.sectionEnum?.title
        lbSubtitle.text = "\(param.indexEnum.rawValue) \(param.day)"
        ivSection.image = param.sectionEnum?.image
        btnTest.isEnabled = !param.indices.isEmpty
        
        initializeTableView()
    }
    
    private func initializeTableView() {
        tableView.rowHeight = CGFloat(CommonConstant.cellSize)
        switch param.sectionEnum {
        case .kanji:
            kanjiTableViewHandler = KanjiTableViewHandler(indices: param.indices)
            kanjiTableViewHandler?.onReload = { [weak self] indexPath in
                self?.onReload(indexPath: indexPath)
            }
            tableView.delegate = kanjiTableViewHandler
            tableView.dataSource = kanjiTableViewHandler
            tableView.register(UINib(nibName: String(describing: KanjiTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: KanjiTableViewCell.self))
        case .vocabulary:
            vocabularyTableViewHandler = VocabularyTableViewHandler(indices: param.indices)
            vocabularyTableViewHandler?.onReload = { [weak self] indexPath in
                self?.onReload(indexPath: indexPath)
            }
            tableView.delegate = vocabularyTableViewHandler
            tableView.dataSource = vocabularyTableViewHandler
            tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kanjiTableViewHandler?.reload()
        vocabularyTableViewHandler?.reload()
        tableView.reloadData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickVisibleAll(_ sender: Any) {
        kanjiTableViewHandler?.setVisibleAll()
        vocabularyTableViewHandler?.setVisibleAll()
        tableView.reloadData()
    }
    
    @IBAction func onClickTest(_ sender: Any) {
        let vc = UIViewController.getViewController(viewControllerEnum: .test) as! TestViewController
        vc.param = TestViewController.Param(indexEnum: param.indexEnum, sectionEnum: param.sectionEnum, day: param.day, indices: param.indices)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickShuffle(_ sender: Any) {
        kanjiTableViewHandler?.shuffleKanjis()
        vocabularyTableViewHandler?.shuffleVocabularies()
        tableView.reloadData()
    }
    
    private func onReload(indexPath: IndexPath) {
        // When the top cell expands, it causes a problem with the reusable cell, causing the animation to operate abnormally.
        guard let visibleRows = tableView.indexPathsForVisibleRows else {
            return
        }
        if visibleRows.firstIndex(of: indexPath) == 0 {
            tableView.reloadSections(IndexSet(visibleRows.map { $0.section }), with: .automatic)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
