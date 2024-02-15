//
//  CustomTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2022/03/24.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbKanji: UILabel!
    @IBOutlet weak var lbHanja: UILabel!
    @IBOutlet weak var btnHanja: UIButton!
    @IBOutlet weak var btnEumhun: UIButton!
    @IBOutlet weak var btnJpSound: UIButton!
    @IBOutlet weak var btnJpMeaning: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    var onClickHanja: ((_ sender: UIButton) -> Void)?
    var onClickEumhun: ((_ sender: UIButton) -> Void)?
    var onClickJpSound: ((_ sender: UIButton) -> Void)?
    var onClickJpMeaning: ((_ sender: UIButton) -> Void)?
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    @IBAction func onClickViewAll(_ sender: UIButton) {
        onClickEumhun?(btnEumhun)
        onClickJpSound?(btnJpSound)
        onClickJpMeaning?(btnJpMeaning)
    }
    @IBAction func onClickBookmark(_ sender: UIButton) {
        onClickBookmark?(sender)
    }
    
}
