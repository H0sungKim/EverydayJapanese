//
//  HiraganaKatakanaPracticeViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.01.14.
//

import UIKit

class HiraganaKatakanaPracticeViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
        var selected: Int
    }
    var param: Param!
    
    private var collectionData: [(String, String)]? {
        get {
            switch param.indexEnum {
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
    
    @IBOutlet weak var btnMain: UIButton!
    
    @IBOutlet weak var strokeOrderAnimationView: StrokeOrderAnimationView!
    @IBOutlet weak var drawingView: DrawingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSection.layer.cornerRadius = 12
        
        ivSection.image = param.indexEnum.section?.image
        lbTitle.text = param.indexEnum.section?.title
        lbSubtitle.text = "\(param.indexEnum.rawValue) 연습"
        
        initializeView()
    }
    
    private func initializeView() {
        var configuration = UIButton.Configuration.plain()
        
        configuration.titleAlignment = .center
        configuration.attributedTitle = AttributedString(collectionData?[param.selected].0 ?? "", attributes: AttributeContainer([
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 48, weight: .bold)
        ]))
        configuration.attributedSubtitle = AttributedString(collectionData?[param.selected].1 ?? "", attributes: AttributeContainer([
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 18)
        ]))
        btnMain.configuration = configuration
        strokeOrderAnimationView.startAnimation(hiraganaKatakana: collectionData?[param.selected].0)
    }
    
    @IBAction func onClickMain(_ sender: Any) {
        let vc: HiraganaKatakanaSelectViewController = HiraganaKatakanaSelectViewController.create()
        vc.param = HiraganaKatakanaSelectViewController.Param(indexEnum: param.indexEnum, selected: param.selected)
        vc.applySelected = { [weak self] index in
            self?.param.selected = index
            self?.drawingView.clear()
            self?.initializeView()
        }
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
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
        strokeOrderAnimationView.startAnimation(hiraganaKatakana: collectionData?[param.selected].0)
    }
}
