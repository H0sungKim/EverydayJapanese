//
//  CustomView.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.03.28.
//

import UIKit
import SkeletonView

class ExampleSentenceView: UIView {
    
    var onClickLink: (() -> Void)?
    var onClickReload: (() -> Void)?
    
    @IBOutlet weak var tvSentence: UITextView!
    @IBOutlet weak var lbKorean: UILabel!
    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var btnLink: UIButton!
    
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
        tvSentence.skeletonTextNumberOfLines = 1
        tvSentence.textColor = .label
        tvSentence.backgroundColor = .clear
        btnLink.isHiddenWhenSkeletonIsActive = true
        btnLink.isUserInteractionDisabledWhenSkeletonIsActive = true
        btnReload.isHiddenWhenSkeletonIsActive = true
        btnReload.isUserInteractionDisabledWhenSkeletonIsActive = true
        let title = "- Tatoeba"
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 12)
        ], range: NSRange(location: 0, length: title.count))
        btnLink.setAttributedTitle(attributedString, for: .normal)
    }
    
    func showSkeleton() {
        tvSentence.showAnimatedGradientSkeleton(transition: .crossDissolve(0))
        btnLink.showAnimatedGradientSkeleton(transition: .crossDissolve(0))
        btnReload.showAnimatedGradientSkeleton(transition: .crossDissolve(0))
        lbKorean.showAnimatedGradientSkeleton(transition: .crossDissolve(0))
    }
    func hideSkeleton() {
        tvSentence.hideSkeleton(transition: .crossDissolve(0))
        btnLink.hideSkeleton(transition: .crossDissolve(0))
        btnReload.hideSkeleton(transition: .crossDissolve(0))
        lbKorean.hideSkeleton(transition: .crossDissolve(0))
    }
    @IBAction func onClickLink(_ sender: UIButton) {
        onClickLink?()
    }
    @IBAction func onClickReload(_ sender: Any) {
        tvSentence.text = ""
        lbKorean.text = ""
        showSkeleton()
        onClickReload?()
    }
}
