//
//  TestResultViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.07.
//

import UIKit

class TestResultViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
        let sectionEnum: SectionEnum?
        let day: String
        let allCount: Int
        let indices: [String]
    }
    var param: Param!
    
    private var vocabularyTableViewHandler: VocabularyTableViewHandler?
    private var kanjiTableViewHandler: KanjiTableViewHandler?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbSubScore: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnReTest: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    private func initializeView() {
        lbTitle.text = param.sectionEnum?.title
        lbSubtitle.text = "\(param.indexEnum.rawValue) \(param.day) 테스트 결과"
        ivSection.image = param.sectionEnum?.image
        
        lbScore.text = "\(Int((param.allCount - param.indices.count) * 100 / param.allCount))점"
        lbSubScore.text = "\(param.allCount - param.indices.count)/\(param.allCount)"
        if param.indices.isEmpty {
            btnBookmark.isEnabled = false
            btnReTest.isEnabled = false
        }
        
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
    
    @IBAction func onClickBookmark(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        kanjiTableViewHandler?.addBookmarkAll()
        vocabularyTableViewHandler?.addBookmarkAll()
        sender.isEnabled = false
        tableView.reloadData()
    }
    
    @IBAction func onClickReTest(_ sender: Any) {
        let vc = UIViewController.getViewController(viewControllerEnum: .test) as! TestViewController
        vc.param = TestViewController.Param(indexEnum: param.indexEnum, sectionEnum: param.sectionEnum, day: param.day, indices: param.indices)
        navigationController?.replaceViewController(viewController: vc, animated: true)
    }
    
    @IBAction func onClickFinishTest(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
