//
//  HiraganaKatakanaCollectionViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.07.
//

import UIKit

class HiraganaKatakanaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    override func awakeFromNib() {
        backGroundView.layer.cornerRadius = 25
    }
}
