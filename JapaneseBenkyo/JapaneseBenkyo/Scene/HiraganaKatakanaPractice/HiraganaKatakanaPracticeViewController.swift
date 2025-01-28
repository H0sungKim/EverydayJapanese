//
//  HiraganaKatakanaPracticeViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.01.14.
//

import UIKit

class HiraganaKatakanaPracticeViewController: UIViewController {
    
    var indexEnum: IndexEnum?
    var selected: Int!
    
    private var collectionData: [(String, String)]? {
        get {
            switch indexEnum {
            case .hiragana:
                return HiraganaKatakanaManager.shared.hiraganaTuple
            case .katakana:
                return HiraganaKatakanaManager.shared.katakanaTuple
            default:
                return nil
            }
        }
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    @IBOutlet weak var strokeOrderAnimationView: StrokeOrderAnimationView!
    @IBOutlet weak var drawingView: DrawingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSection.image = indexEnum?.getSection()?.image
        lbTitle.text = indexEnum?.getSection()?.title
        lbSubtitle.text = "\(indexEnum?.rawValue ?? "") 연습"
        
        lbMain.text = collectionData?[selected].0
        lbSub.text = collectionData?[selected].1
        
        strokeOrderAnimationView.startAnimation(hiraganaKatakana: collectionData?[selected ?? 0].0)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickUndo(_ sender: Any) {
        drawingView.undo()
    }
    @IBAction func onClickClear(_ sender: Any) {
        drawingView.clear()
    }
    
    @IBAction func onClickRefresh(_ sender: Any) {
        drawingView.clear()
        strokeOrderAnimationView.startAnimation(hiraganaKatakana: collectionData?[selected].0)
    }
}
