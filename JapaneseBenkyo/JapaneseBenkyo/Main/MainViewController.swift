//
//  Main2ViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.08.31.
//

import UIKit

protocol Section {
    var title: String { get }
    var image: UIImage { get }
    var indexs: [IndexEnum] { get }
    var tableViewCell: UITableViewCell.Type { get }
}

enum SectionEnum: Section, CaseIterable {
    var tableViewCell: UITableViewCell.Type {
        switch self {
        case .hiraganakatagana:
            return UITableViewCell.self
        case .kanji:
            return KanjiTableViewCell.self
        case .vocabulary:
            return VocabularyTableViewCell.self
        }
    }
    
    
    case hiraganakatagana
    case kanji
    case vocabulary
    
    var title: String {
        switch self {
        case .hiraganakatagana:
            return "히라가나 가타가나 표"
        case .kanji:
            return "일본 상용한자"
        case .vocabulary:
            return "JLPT 단어장"
        }
    }
    
    var image: UIImage {
        switch self {
        case .hiraganakatagana:
            return UIImage(named: "hiraganakatakana.png")!
        case .kanji:
            return UIImage(named: "kanji.png")!
        case .vocabulary:
            return UIImage(named: "jlpt.png")!
        }
    }
    
    var indexs: [IndexEnum] {
        switch self {
        case .hiraganakatagana:
            return [
                .hiragana,
                .katakana,
            ]
        case .kanji:
            return [
                .bookmark,
                .elementary1,
                .elementary2,
                .elementary3,
                .elementary4,
                .elementary5,
                .elementary6,
                .middle,
            ]
        case .vocabulary:
            return [
                .bookmark,
                .n5,
                .n4,
                .n3,
                .n2,
                .n1,
            ]
        }
    }
}

enum IndexEnum: String, CaseIterable {
    case bookmark = "즐겨찾기"
    case hiragana = "히라가나"
    case katakana = "가타카나"
    case elementary1 = "소학교 1학년"
    case elementary2 = "소학교 2학년"
    case elementary3 = "소학교 3학년"
    case elementary4 = "소학교 4학년"
    case elementary5 = "소학교 5학년"
    case elementary6 = "소학교 6학년"
    case middle = "중학교"
    case n5 = "N5"
    case n4 = "N4"
    case n3 = "N3"
    case n2 = "N2"
    case n1 = "N1"
    
    func getFileName() -> String {
        switch self {
        case .bookmark, .hiragana, .katakana:
            return ""
        case .elementary1:
            return "kanji1"
        case .elementary2:
            return "kanji2"
        case .elementary3:
            return "kanji3"
        case .elementary4:
            return "kanji4"
        case .elementary5:
            return "kanji5"
        case .elementary6:
            return "kanji6"
        case .middle:
            return "kanji7"
        case .n5:
            return "n5"
        case .n4:
            return "n4"
        case .n3:
            return "n3"
        case .n2:
            return "n2"
        case .n1:
            return "n1"
        }
    }
    
    func getSection() -> SectionEnum? {
        switch self {
        case .bookmark:
            return nil
        case .hiragana, .katakana:
            return .hiraganakatagana
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle:
            return .kanji
        case .n5, .n4, .n3, .n2, .n1:
            return .vocabulary
        }
    }
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var process: [String: [String: Bool]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BUILD LOG ====================
        NSLog("Build : 2024.02.15 18:16")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: Index2TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: Index2TableViewCell.self))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
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
            return SectionEnum.hiraganakatagana.indexs.count+1
        case .kanji :
            return SectionEnum.kanji.indexs.count+1
        case .vocabulary :
            return SectionEnum.vocabulary.indexs.count+1
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
        } else {
            let cell: Index2TableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: Index2TableViewCell.self), for: indexPath) as? Index2TableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: Index2TableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! Index2TableViewCell
            }
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1], process: process[SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1].rawValue]?["전체보기"])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        switch SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1] {
        case .bookmark:
            switch SectionEnum.allCases[indexPath.section] {
            case .hiraganakatagana:
                break
            case .kanji:
                let vc = UIViewController.getViewController(viewControllerEnum: .kanjistudy) as! KanjiStudyViewController
                vc.level = SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1].rawValue
                if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
                    vc.kanjisForCell = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData).map { KanjiForCell(kanji: $0) }
                }
                navigationController?.pushViewController(vc, animated: true)
            case .vocabulary:
                let vc = UIViewController.getViewController(viewControllerEnum: .vocabularystudy) as! VocabularyStudyViewController
                vc.level = SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1].rawValue
                if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
                    vc.vocabulariesForCell = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData).map { VocabularyForCell(vocabulary: $0) }
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        case .hiragana:
            break
        case .katakana:
            break
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle, .n5, .n4, .n3, .n2, .n1:
            let vc = UIViewController.getViewController(viewControllerEnum: .day) as! DayViewController
            vc.initializeView(index: SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1])
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 50
    }
}
