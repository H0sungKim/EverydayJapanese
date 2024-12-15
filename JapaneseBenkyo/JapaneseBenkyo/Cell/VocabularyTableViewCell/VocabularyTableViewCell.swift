//
//  CustomTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2022/03/24.
//

import UIKit

class VocabularyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbWord: UILabel!
    @IBOutlet weak var lbSound: UILabel!
    @IBOutlet weak var lbMeaning: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    var onClickPronounce: ((_ sender: UIButton) -> Void)?
    var onClickExpand: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbWord.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func onClickBookmark(_ sender: UIButton) {
        onClickBookmark?(sender)
    }
    @IBAction func onClickPronounce(_ sender: UIButton) {
        onClickPronounce?(sender)
    }
    @IBAction func onClickExpand(_ sender: UIButton) {
        onClickExpand?(sender)
    }
}
