//
//  Main2ViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.08.31.
//

import UIKit
import AdFitSDK
import AppTrackingTransparency

class MainViewController: UIViewController {
    
    private var nativeAd: AdFitNativeAd?
    private var nativeAdLoader: AdFitNativeAdLoader?
    private var adLoaded: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nativeAdLoader = AdFitNativeAdLoader(clientId: Bundle.main.adMyKey!)
        nativeAdLoader?.delegate = self
        nativeAdLoader?.infoIconPosition = .topRight
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                self?.nativeAdLoader?.loadAd()
            }
        } else {
            nativeAdLoader?.loadAd()
        }
        
        tableView.register(UINib(nibName: String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: PassTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PassTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: IndexTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IndexTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: AdTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AdTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionEnum.allCases[section] {
        case .ad:
            return adLoaded ? 1 : 0
        case .hiraganakatagana:
            return SectionEnum.hiraganakatagana.indexEnums.count+1
        case .kanji:
            return SectionEnum.kanji.indexEnums.count+2
        case .vocabulary:
            return SectionEnum.vocabulary.indexEnums.count+2
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let adTableViewCell = cell as? AdTableViewCell {
            if let nativeAd = nativeAd {
                nativeAd.bind(adTableViewCell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            switch SectionEnum.allCases[indexPath.section] {
            case .ad:
                let cell: AdTableViewCell = AdTableViewCell.create(tableView: tableView, indexPath: indexPath)
//                cell.bgViewColor = .clear
//                cell.bgViewBottomMargin = 0
//                cell.bgViewTopMargin = 0
//                cell.bgViewRightMargin = 0
//                cell.bgViewleftMargin = 0
//                adHeight = cell.contentView.frame.width / 2
                return cell
            case .hiraganakatagana, .kanji, .vocabulary:
                let cell: HeaderTableViewCell = HeaderTableViewCell.create(tableView: tableView, indexPath: indexPath)
                cell.initializeView(section: SectionEnum.allCases[indexPath.section])
                return cell
            }
        }
        switch SectionEnum.allCases[indexPath.section] {
        case .ad:
            let cell: BizBoardCell = BizBoardCell.create(tableView: tableView, indexPath: indexPath)
            return cell
        case .hiraganakatagana:
            let cell: IndexTableViewCell = IndexTableViewCell.create(tableView: tableView, indexPath: indexPath)
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-1])
            return cell
        case .kanji, .vocabulary:
            if indexPath.row == 1 {
                let cell: PassTableViewCell = PassTableViewCell.create(tableView: tableView, indexPath: indexPath)
                cell.initializeView(passCount: SectionEnum.allCases[indexPath.section].pass.count, totalCount: GlobalDataManager.shared.getCount(section: SectionEnum.allCases[indexPath.section]))
                return cell
            }
            let cell: IndexTableViewCell = IndexTableViewCell.create(tableView: tableView, indexPath: indexPath)
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-2])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let indexEnum: IndexEnum? = {
            switch SectionEnum.allCases[indexPath.section] {
            case .ad:
                return nil
            case .hiraganakatagana:
                return indexPath.row == 0 ? nil : SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-1]
            case .kanji, .vocabulary:
                return indexPath.row == 0 || indexPath.row == 1 ? nil : SectionEnum.allCases[indexPath.section].indexEnums[indexPath.row-2]
            }
        }()
        
        switch indexEnum {
        case .bookmark:
            let vc: StudyViewController = StudyViewController.create()
            vc.param = StudyViewController.Param(indexEnum: .bookmark, sectionEnum: SectionEnum.allCases[indexPath.section], day: "", indices: Array(SectionEnum.allCases[indexPath.section].bookmark))
            navigationController?.pushViewController(vc, animated: true)
        case .hiragana, .katakana:
            let vc: HiraganaKatakanaViewController = HiraganaKatakanaViewController.create()
            vc.param = HiraganaKatakanaViewController.Param(indexEnum: indexEnum!)
            navigationController?.pushViewController(vc, animated: true)
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle, .n5, .n4, .n3, .n2, .n1:
            let vc: DayViewController = DayViewController.create()
            vc.param = DayViewController.Param(indexEnum: indexEnum!)
            navigationController?.pushViewController(vc, animated: true)
        case nil:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            switch SectionEnum.allCases[indexPath.section] {
            case .ad:
                return UITableView.automaticDimension
            case .hiraganakatagana, .kanji, .vocabulary:
                return 70
            }
        case 1:
            switch SectionEnum.allCases[indexPath.section] {
            case .kanji, .vocabulary:
                return 20
            default:
                break
            }
        default:
            break
        }
        return 50
    }
}

extension MainViewController: AdFitNativeAdLoaderDelegate, AdFitNativeAdDelegate {
    func nativeAdLoaderDidReceiveAd(_ nativeAd: AdFitNativeAd) {
        self.nativeAd = nativeAd
        adLoaded = true
        tableView.reloadData()
        print("광고 응답을 받았습니다.")
    }
    
    func nativeAdLoaderDidFailToReceiveAd(_ nativeAdLoader: AdFitNativeAdLoader, error: any Error) {
        tableView.reloadData()
        adLoaded = false
        print("광고 응답 에러: \(error) (\(error.localizedDescription))")
    }
    
    func nativeAdDidClickAd(_ nativeAd: AdFitNativeAd) {
        print("광고 클릭")
    }
}
