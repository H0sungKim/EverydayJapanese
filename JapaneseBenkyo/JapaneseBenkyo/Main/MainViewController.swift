//
//  MainViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

// TODO
// * test

import UIKit

enum CatalogueEnum: String, CaseIterable {
    case vocabulary = "일본어 단어장"
    case kanji = "일본어 한자"
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let catalogues: [CatalogueEnum] = CatalogueEnum.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BUILD LOG ====================
        NSLog("Build : 2024.02.15 18:16")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
        }

        cell.lbTitle.text = catalogues[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController.getViewController(catalogueEnum: catalogues[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
