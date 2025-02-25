//
//  AdTableViewCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.25.
//

import UIKit
import AdFitSDK

class AdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbProfile: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var mediaView: AdFitMediaView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivIcon.layer.cornerRadius = 16
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AdTableViewCell: AdFitNativeAdRenderable {
    // MARK: - AdFitNativeAdRenderable
    func adTitleLabel() -> UILabel? {
        return lbTitle
    }
    
    func adCallToActionButton() -> UIButton? {
        return nil
    }
    
    func adProfileNameLabel() -> UILabel? {
        return lbProfile
    }
    
    func adProfileIconView() -> UIImageView? {
        return ivIcon
    }
    
    func adMediaView() -> AdFitMediaView? {
        return mediaView
    }
    
    
}
