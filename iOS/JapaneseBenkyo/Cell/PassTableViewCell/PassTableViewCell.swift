//
//  HeaderTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.08.31.
//

import UIKit

class PassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pvPass: UIProgressView!
    @IBOutlet weak var lbPass: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initializeView(passCount: Int, totalCount: Int) {
        pvPass.progress = Float(passCount) / Float(totalCount)
        lbPass.text = "\(passCount)/\(totalCount)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
