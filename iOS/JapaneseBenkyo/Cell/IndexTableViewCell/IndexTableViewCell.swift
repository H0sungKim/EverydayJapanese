//
//  IndexTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.01.
//

import UIKit

enum StudyProgress {
    case notStarted
    case doing
    case done
    
    var image: UIImage? {
        switch self {
        case .notStarted:
            return UIImage(systemName: "circle")
        case .doing, .done:
            return UIImage(systemName: "checkmark.circle")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .notStarted:
            return .systemGray
        case .doing:
            return .systemYellow
        case .done:
            return .systemGreen
        }
    }
}

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
            lbSubtitle.text = ""
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle:
            let progress: StudyProgress
            let studiedIndices = Set(index.idRange.map({ String($0) })).intersection(GroupedUserDefaultsManager.shared.passKanji)
            if studiedIndices.count == 0 {
                progress = .notStarted
            } else if studiedIndices.count < index.idRange.count {
                progress = .doing
            } else {
                progress = .done
            }
            ivProcess.image = progress.image
            ivProcess.tintColor = progress.tintColor
            
            lbSubtitle.text = "\(studiedIndices.count)/\(index.idRange.count)"
        case .n5, .n4, .n3, .n2, .n1:
            let progress: StudyProgress
            let studiedIndices = Set(index.idRange.map({ String($0) })).intersection(GroupedUserDefaultsManager.shared.passVoca)
            if studiedIndices.count == 0 {
                progress = .notStarted
            } else if studiedIndices.count < index.idRange.count {
                progress = .doing
            } else {
                progress = .done
            }
            ivProcess.image = progress.image
            ivProcess.tintColor = progress.tintColor
            
            lbSubtitle.text = "\(studiedIndices.count)/\(index.idRange.count)"
        case .hiragana:
            ivProcess.image = UIImage(named: "hiragana_hi.png")!
            lbSubtitle.text = ""
        case .katakana:
            ivProcess.image = UIImage(named: "katakana_ka.png")!
            lbSubtitle.text = ""
        }
        lbTitle.text = index.rawValue
    }
    
    func initializeView(title: String, completed: Int, total: Int) {
        let progress: StudyProgress
        if completed == 0 {
            progress = .notStarted
        } else if completed < total {
            progress = .doing
        } else {
            progress = .done
        }
        
        ivProcess.image = progress.image
        ivProcess.tintColor = progress.tintColor
        
        lbTitle.text = title
        
        lbSubtitle.text = "\(completed)/\(total)"
    }
}
