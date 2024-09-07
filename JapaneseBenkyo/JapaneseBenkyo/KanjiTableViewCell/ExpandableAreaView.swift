//
//  CustomView.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.03.28.
//

import UIKit

class ExpandableAreaView: UIView {

    @IBOutlet weak var lbTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        initializeView()
    }
    
    func initializeView() {
        lbTitle.adjustsFontSizeToFitWidth = true
        lbTitle.clipsToBounds = true
    }
}
