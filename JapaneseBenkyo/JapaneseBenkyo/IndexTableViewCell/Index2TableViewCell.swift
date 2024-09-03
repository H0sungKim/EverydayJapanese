//
//  Index2TableViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.01.
//

import UIKit

class Index2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivProcess: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeView(index: IndexEnum, process: Bool?) {
        switch index {
        case .bookmark:
            ivProcess.image = UIImage(named: "star.png")!
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle, .n5, .n4, .n3, .n2, .n1:
            if let process = process, process {
                ivProcess.image = UIImage(systemName: "checkmark.circle")
                ivProcess.tintColor = .systemGreen
            } else {
                ivProcess.image = UIImage(systemName: "circle")
                ivProcess.tintColor = .systemGray
            }
        case .hiragana, .katakana:
            ivProcess.image = nil
        }
        lbTitle.text = index.rawValue
    }
}
