//
//  CustomTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2022/03/24.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbKanji: UILabel!
    @IBOutlet weak var lbEumhun: UILabel!
    @IBOutlet weak var lbJpSound: UILabel!
    @IBOutlet weak var lbJpMeaning: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scHanja: UISegmentedControl!
    
    var valueChangedHanja: ((_ sender: UISegmentedControl) -> Void)?
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    var onClickPronounce: ((_ sender: UIButton) -> Void)?
    var onClickExpand: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbJpSound.adjustsFontSizeToFitWidth = true
        lbJpMeaning.adjustsFontSizeToFitWidth = true
        lbEumhun.adjustsFontSizeToFitWidth = true
    }
    @IBAction func valueChangedHanja(_ sender: UISegmentedControl) {
        valueChangedHanja?(sender)
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
