//
//  ViewController.swift
//  JapaneseVocabulary
//
//  Created by 김기훈 on 2022/03/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let titleText: [String] = ["즐겨찾기", "JLPT5", "JLPT4", "JLPT3", "JLPT2", "JLPT1"]
    
    @IBOutlet weak var tbvTable: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell

        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: CustomTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! CustomTableViewCell
//            if indexPath.row == 0 {
//                cell.icon.image = UIImage(named: "star.fill")
//            }
        }

        cell.labelTitle.text = titleText[indexPath.row]
        return cell

    }
    // 클릭됐을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let wordViewController = self.storyboard?.instantiateViewController(withIdentifier: "wordviewcontroller") as? WordViewController {
            wordViewController.menu = titleText[indexPath.row]
            wordViewController.modalPresentationStyle = .fullScreen
            present(wordViewController, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvTable.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomTableViewCell.self))

    }
    @IBAction func infoOnClick(_ sender: Any) {
        
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    
}
