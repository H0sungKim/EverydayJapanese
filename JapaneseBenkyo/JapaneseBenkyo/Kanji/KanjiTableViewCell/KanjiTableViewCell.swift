//
//  CustomTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2022/03/24.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbKanji: UILabel!
    @IBOutlet weak var btnHanja: UIButton!
    @IBOutlet weak var lbEumhun: UILabel!
    @IBOutlet weak var btnEumhun: UIButton!
    @IBOutlet weak var lbJpSound: UILabel!
    @IBOutlet weak var btnJpSound: UIButton!
    @IBOutlet weak var lbJpMeaning: UILabel!
    @IBOutlet weak var btnJpMeaning: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var lcExampleHeight: NSLayoutConstraint!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var onClickHanja: ((_ sender: UIButton) -> Void)?
    var onClickEumhun: ((_ sender: UIButton) -> Void)?
    var onClickJpSound: ((_ sender: UIButton) -> Void)?
    var onClickJpMeaning: ((_ sender: UIButton) -> Void)?
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    var onClickPronounce: ((_ sender: UIButton) -> Void)?
    var onClickExpand: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbJpSound.adjustsFontSizeToFitWidth = true
        lbJpMeaning.adjustsFontSizeToFitWidth = true
        lbEumhun.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func onClickHanja(_ sender: UIButton) {
        onClickHanja?(sender)
    }
    @IBAction func onClickEumhun(_ sender: UIButton) {
        onClickEumhun?(sender)
    }
    @IBAction func onClickJpSound(_ sender: UIButton) {
        onClickJpSound?(sender)
    }
    @IBAction func onClickJpMeaning(_ sender: UIButton) {
        onClickJpMeaning?(sender)
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
