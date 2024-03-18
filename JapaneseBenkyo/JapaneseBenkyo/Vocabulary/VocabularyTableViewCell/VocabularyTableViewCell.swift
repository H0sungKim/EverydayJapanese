//
//  CustomTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2022/03/24.
//

import UIKit

class VocabularyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbWord: UILabel!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var lbSound: UILabel!
    @IBOutlet weak var btnMeaning: UIButton!
    @IBOutlet weak var lbMeaning: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    var onClickSound: ((_ sender: UIButton) -> Void)?
    var onClickMeaning: ((_ sender: UIButton) -> Void)?
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMeaning.titleLabel?.textAlignment = .center
        lbWord.adjustsFontSizeToFitWidth = true
        btnSound.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func onClickSound(_ sender: UIButton) {
        onClickSound?(sender)
    }
    @IBAction func onClickMeaning(_ sender: UIButton) {
        onClickMeaning?(sender)
    }
    @IBAction func onClickBookmark(_ sender: UIButton) {
        onClickBookmark?(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
