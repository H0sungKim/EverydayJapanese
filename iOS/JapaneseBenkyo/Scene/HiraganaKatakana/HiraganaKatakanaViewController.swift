//
//  HiraganaKatakanaViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.07.
//

import UIKit

class HiraganaKatakanaViewController: UIViewController {
    
    struct Param {
        let indexEnum: IndexEnum
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
    
    @IBOutlet weak var cvHiraganaKatakana: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSection.layer.cornerRadius = 12
        
        ivSection.image = param.indexEnum.section?.image
        lbTitle.text = param.indexEnum.section?.title
        lbSubtitle.text = param.indexEnum.rawValue
        
        cvHiraganaKatakana.delegate = self
        cvHiraganaKatakana.dataSource = self
        cvHiraganaKatakana.register(UINib(nibName: String(describing: HiraganaKatakanaCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HiraganaKatakanaCollectionViewCell.self))
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickTest(_ sender: Any) {
        let vc: HiraganaKatakanaTestViewController = HiraganaKatakanaTestViewController.create()
        vc.param = HiraganaKatakanaTestViewController.Param(indexEnum: param.indexEnum)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HiraganaKatakanaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HiraganaKatakanaCollectionViewCell = HiraganaKatakanaCollectionViewCell.create(collectionView: collectionView, indexPath: indexPath)
        
        guard let collectionData = collectionData else {
            return cell
        }
        cell.lbMain.text = collectionData[indexPath.row].0
        cell.lbSub.text = collectionData[indexPath.row].1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Int = Int(collectionView.frame.width/5)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionData = collectionData else {
            return
        }
        if collectionData[indexPath.row].0 == "" { return }
        let vc: HiraganaKatakanaPracticeViewController = HiraganaKatakanaPracticeViewController.create()
        vc.param = HiraganaKatakanaPracticeViewController.Param(indexEnum: param.indexEnum, selected: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}
