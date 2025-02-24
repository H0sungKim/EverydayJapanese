//
//  DayViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.06.
//

import UIKit

class DayViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
    }
    var param: Param!
    
    private var indices: [Array<String>] = []
    private var pass: [Int] = []
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var pvPass: UIProgressView!
    @IBOutlet weak var lbProcess: UILabel!
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        tableView.register(UINib(nibName: String(describing: IndexTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IndexTableViewCell.self))
        
        indices = stride(from: param.indexEnum.idRange.lowerBound, through: param.indexEnum.idRange.upperBound, by: CommonConstant.daySize).map({
            Array($0...min($0 + CommonConstant.daySize - 1, param.indexEnum.idRange.upperBound)).map({ String($0) })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        let bookmark: Set<String> = param.indexEnum.section?.pass ?? []
        pass = indices.map({ day in
            return day.count(where: { bookmark.contains($0) })
        })
        let passCount = pass.reduce(0, +)
        let totalCount = indices.map(\.count).reduce(0, +)
        pvPass.progress = Float(passCount) / Float(totalCount)
        lbProcess.text = "\(passCount)/\(totalCount)"
    }
    
    func initializeView() {
        ivSection.layer.cornerRadius = 16
        ivSection.image = param.indexEnum.section?.image
        lbTitle.text = param.indexEnum.section?.title
        lbSubtitle.text = param.indexEnum.rawValue
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indices.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! IndexTableViewCell
        }
        
        cell.initializeView(
            title: indexPath.row == 0 ? "전체보기" : "Day\(indexPath.row)",
            process: indexPath.row == 0 ? pass.reduce(0, +) == indices.map(\.count).reduce(0, +) : pass[indexPath.row-1] == indices[indexPath.row-1].count
        )
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(viewControllerEnum: .study) as! StudyViewController
        vc.param = StudyViewController.Param(
            indexEnum: param.indexEnum,
            sectionEnum: param.indexEnum.section,
            day: indexPath.row == 0 ? "전체보기" : "Day\(indexPath.row)",
            indices: indexPath.row == 0 ? indices.flatMap { $0 } : indices[indexPath.row - 1]
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
