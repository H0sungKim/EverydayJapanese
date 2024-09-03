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
}

enum SectionEnum: Section, CaseIterable {
    
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
}

class Main2ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var process: [String: [String: Bool]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension Main2ViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 50
    }
}
