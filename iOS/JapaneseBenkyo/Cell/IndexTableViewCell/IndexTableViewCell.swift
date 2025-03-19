//
//  IndexTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.01.
//

import UIKit

class IndexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivProcess: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeView(index: IndexEnum) {
        switch index {
        case .bookmark:
            ivProcess.image = UIImage(named: "star.png")!
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle:
            let allPass = Set(index.idRange.map({ String($0) })).isSubset(of: GroupedUserDefaultsManager.shared.passKanji)
            ivProcess.image = allPass ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
            ivProcess.tintColor = allPass ? .systemGreen : .systemGray
        case .n5, .n4, .n3, .n2, .n1:
            let allPass = Set(index.idRange.map({ String($0) })).isSubset(of: GroupedUserDefaultsManager.shared.passVoca)
            ivProcess.image = allPass ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
            ivProcess.tintColor = allPass ? .systemGreen : .systemGray
        case .hiragana:
            ivProcess.image = UIImage(named: "hiragana_hi.png")!
        case .katakana:
            ivProcess.image = UIImage(named: "katakana_ka.png")!
        }
        lbTitle.text = index.rawValue
    }
    
    func initializeView(title: String, process: Bool?) {
        if let process = process, process {
            ivProcess.image = UIImage(systemName: "checkmark.circle")
            ivProcess.tintColor = .systemGreen
        } else {
            ivProcess.image = UIImage(systemName: "circle")
            ivProcess.tintColor = .systemGray
        }
        lbTitle.text = title
    }
}
