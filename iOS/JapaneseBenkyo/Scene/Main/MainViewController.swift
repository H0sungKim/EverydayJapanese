//
//  Main2ViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.08.31.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: PassTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PassTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: IndexTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IndexTableViewCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionEnum.allCases[section] {
        case .hiraganakatagana :
            return SectionEnum.hiraganakatagana.indexEnums.count+1
        case .kanji :
            return SectionEnum.kanji.indexEnums.count+2
        case .vocabulary :
            return SectionEnum.vocabulary.indexEnums.count+2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: HeaderTableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self), for: indexPath) as? HeaderTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: HeaderTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! HeaderTableViewCell
            }
            cell.initializeView(section: SectionEnum.allCases[indexPath.section])
            return cell
        }
        switch SectionEnum.allCases[indexPath.section] {
        case .hiraganakatagana:
            let cell: IndexTableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! IndexTableViewCell
            }
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-1])
            return cell
        case .kanji, .vocabulary:
            if indexPath.row == 1 {
                let cell: PassTableViewCell
                if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PassTableViewCell.self), for: indexPath) as? PassTableViewCell {
                    cell = reusableCell
                } else {
                    let objectArray = Bundle.main.loadNibNamed(String(describing: PassTableViewCell.self), owner: nil, options: nil)
                    cell = objectArray![0] as! PassTableViewCell
                }
                
                cell.initializeView(passCount: SectionEnum.allCases[indexPath.section].pass.count, totalCount: GlobalDataManager.shared.getCount(section: SectionEnum.allCases[indexPath.section]))
                return cell
            }
            let cell: IndexTableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! IndexTableViewCell
            }
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-2])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let indexEnum: IndexEnum? = {
            switch SectionEnum.allCases[indexPath.section] {
            case .hiraganakatagana:
                return indexPath.row == 0 ? nil : SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-1]
            case .kanji, .vocabulary:
                return indexPath.row == 0 || indexPath.row == 1 ? nil : SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-2]
            }
        }()
        
        switch indexEnum {
        case .bookmark:
            let vc = UIViewController.getViewController(viewControllerEnum: .study) as! StudyViewController
            vc.param = StudyViewController.Param(indexEnum: .bookmark, sectionEnum: SectionEnum.allCases[indexPath.section], day: "", indices: Array(SectionEnum.allCases[indexPath.section].bookmark))
            navigationController?.pushViewController(vc, animated: true)
        case .hiragana, .katakana:
            let vc = UIViewController.getViewController(viewControllerEnum: .hiraganakatakana) as! HiraganaKatakanaViewController
            vc.param = HiraganaKatakanaViewController.Param(indexEnum: indexEnum!)
            navigationController?.pushViewController(vc, animated: true)
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle, .n5, .n4, .n3, .n2, .n1:
            let vc = UIViewController.getViewController(viewControllerEnum: .day) as! DayViewController
            vc.param = DayViewController.Param(indexEnum: indexEnum!)
            navigationController?.pushViewController(vc, animated: true)
        case nil:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        if indexPath.row == 1 {
            switch SectionEnum.allCases[indexPath.section] {
            case .kanji, .vocabulary:
                return 20
            default:
                break
            }
        }
        return 50
    }
}
