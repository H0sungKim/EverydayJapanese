//
//  HiraganaKatakanaViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.09.07.
//

import UIKit

class HiraganaKatakanaViewController: UIViewController {
    
    var indexEnum: IndexEnum?
    
    private let hiragana: [(String, String)] = [
        ("あ", "아 a"), ("い", "이 i"), ("う", "우 u"), ("え", "에 e"), ("お", "오 o"),
        ("か", "카 ka"), ("き", "키 ki"), ("く", "쿠 ku"), ("け", "케 ke"), ("こ", "코 ko"),
        ("さ", "사 sa"), ("し", "시 si"), ("す", "스 su"), ("せ", "세 se"), ("そ", "소 so"),
        ("た", "타 ta"), ("ち", "치 chi"), ("つ", "츠 tsu"), ("て", "테 te"), ("と", "토 to"),
        ("な", "나 na"), ("に", "니 ni"), ("ぬ", "누 nu"), ("ね", "네 ne"), ("の", "노 no"),
        ("は", "하 ha"), ("ひ", "히 hi"), ("ふ", "후 hu"), ("へ", "헤 he"), ("ほ", "호 ho"),
        ("ま", "마 ma"), ("み", "미 mi"), ("む", "무 mu"), ("め", "메 me"), ("も", "모 mo"),
        ("や", "야 ya"), ("", ""), ("ゆ", "유 yu"), ("", ""), ("よ", "요 yo"),
        ("ら", "라 ra"), ("り", "리 ri"), ("る", "루 ru"), ("れ", "레 re"), ("ろ", "로 ro"),
        ("わ", "와 wa"), ("", ""), ("", ""), ("", ""), ("を", "오 wo"),
        ("ん", "응 n"), ("", ""), ("", ""), ("", ""), ("", ""),
    ]
    
    private let katakana: [(String, String)] = [
        ("ア", "아 a"), ("イ", "이 i"), ("ウ", "우 u"), ("エ", "에 e"), ("オ", "오 o"),
        ("カ", "카 ka"), ("キ", "키 ki"), ("ク", "쿠 ku"), ("ケ", "케 ke"), ("コ", "코 ko"),
        ("サ", "사 sa"), ("シ", "시 si"), ("ス", "스 su"), ("セ", "세 se"), ("ソ", "소 so"),
        ("タ", "타 ta"), ("チ", "치 chi"), ("ツ", "츠 tsu"), ("テ", "테 te"), ("ト", "토 to"),
        ("ナ", "나 na"), ("ニ", "니 ni"), ("ヌ", "누 nu"), ("ネ", "네 ne"), ("ノ", "노 no"),
        ("ハ", "하 ha"), ("ヒ", "히 hi"), ("フ", "후 hu"), ("ヘ", "헤 he"), ("ホ", "호 ho"),
        ("マ", "마 ma"), ("ミ", "미 mi"), ("ム", "무 mu"), ("メ", "메 me"), ("モ", "모 mo"),
        ("ヤ", "야 ya"), ("", ""), ("ユ", "유 yu"), ("", ""), ("ヨ", "요 yo"),
        ("ラ", "라 ra"), ("リ", "리 ri"), ("ル", "루 ru"), ("レ", "레 re"), ("ロ", "로 ro"),
        ("ワ", "와 wa"), ("", ""), ("", ""), ("", ""), ("ヲ", "오 wo"),
        ("ン", "응 n"), ("", ""), ("", ""), ("", ""), ("", ""),
    ]
    
    private var collectionData: [(String, String)]? {
        get {
            switch indexEnum {
            case .hiragana:
                return hiragana
            case .katakana:
                return katakana
            default:
                return nil
            }
        }
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivSection: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSection.image = indexEnum?.getSection()?.image
        lbTitle.text = indexEnum?.getSection()?.title
        lbSubtitle.text = indexEnum?.rawValue
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: HiraganaKatakanaCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HiraganaKatakanaCollectionViewCell.self))
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension HiraganaKatakanaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HiraganaKatakanaCollectionViewCell
        if let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HiraganaKatakanaCollectionViewCell.self), for: indexPath) as? HiraganaKatakanaCollectionViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: HiraganaKatakanaCollectionViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! HiraganaKatakanaCollectionViewCell
        }
        
        guard let collectionData = collectionData else {
            return cell
        }
        cell.lbMain.text = collectionData[indexPath.row].0
        cell.lbSub.text = collectionData[indexPath.row].1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-5)/5
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 컬랙션뷰 행 하단 여백
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 컬랙션뷰 컬럼 사이 여백
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionData = collectionData else {
            return
        }
        TTSManager.shared.play(line: collectionData[indexPath.row].0)
    }
}
