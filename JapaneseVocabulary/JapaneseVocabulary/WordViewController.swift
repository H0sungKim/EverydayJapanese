//
//  WordViewController.swift
//  JapaneseVocabulary
//
//  Created by 김기훈 on 2022/03/24.
//

import UIKit

class WordViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meanButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageSlider: UISlider!
    @IBOutlet weak var starButton: UIButton!
    
    var isShowingMean: Bool = false
    var menu: String = ""
    var word: [String] = []
    var mean: [String] = []
    var favorites: [Bool] = []
    var page: Int = 0
    
    // 즐겨찾기 데이터
    
    // 별 클릭할때마다 색 채우고 즐겨찾기 데이터에 추가

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(menu)
        if menu == "즐겨찾기" {
            let defaults = UserDefaults.standard
            for i in 1...5 {
                do {
                    let temp:String? = defaults.string(forKey: "JLPT\(i)favorites")
                    
                    if temp != nil {
                        if let filepath = Bundle.main.path(forResource: "JLPT\(i)", ofType: "txt") {
                            do {
                                let contents = try String(contentsOfFile: filepath)
                                let arr = contents.components(separatedBy: "\n")
                                for j in 0..<temp!.count {
                                    if temp![temp!.index(temp!.startIndex, offsetBy: j)] == "1" {
                                        var tempStr = arr[2*j]
                                        if tempStr.contains("[") {
                                            for k in 0..<tempStr.count {
                                                if tempStr[tempStr.index(tempStr.startIndex, offsetBy: k)] == "[" {
                                                    tempStr.insert("\n", at: tempStr.index(tempStr.startIndex, offsetBy: k))
                                                    break
                                                }
                                            }
                                        }
                                        word.append(tempStr)
                                        mean.append(arr[2*j+1])
                                        favorites.append(true)
                                    }
                                }
                            } catch let error as NSError {
                                print("Error Reading File : \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        } else {
            // txt파일 읽어서 단어들 배열에 입력하기
            if let filepath = Bundle.main.path(forResource: menu, ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    let arr = contents.components(separatedBy: "\n")
                    for i in 0..<arr.count {
                        if (i % 2) == 0 {
                            var temp = arr[i]
                            if temp.contains("[") {
                                for j in 0..<temp.count {
                                    if temp[temp.index(temp.startIndex, offsetBy: j)] == "[" {
                                        temp.insert("\n", at: temp.index(temp.startIndex, offsetBy: j))
                                        break
                                    }
                                }
                            }
                            word.append(temp)
                        } else {
                            mean.append(arr[i])
                        }
                    }
//                    print(word)
//                    print(mean)
                } catch let error as NSError {
                    print("Error Reading File : \(error.localizedDescription)")
                }
            }
            let defaults = UserDefaults.standard
            do {
                let temp:String? = defaults.string(forKey: "\(menu)page")
                if temp != nil {
                    page = Int(temp!)!
                } else {
                    print("nil")
                }
            }
            do {
                var temp:String? = defaults.string(forKey: "\(menu)favorites")
                if temp == nil {
                    temp = ""
                    for _ in 0..<word.count {
                        temp?.append("0")
                    }
                }
                for i in temp! {
                    if i == "0" {
                        favorites.append(false)
                    } else {
                        favorites.append(true)
                    }
                }
            }
        }
        //print(String(page))
//        print(word)
        if word.count == 0 {
            return
        }
        wordLabel.numberOfLines = 0
        wordLabel.textAlignment = .center
        meanButton.titleLabel?.numberOfLines = 0
        meanButton.titleLabel?.textAlignment = .center
        wordLabel.text = word[page]
        pageLabel.text = String(page+1)
        pageSlider.minimumValue = 0
        pageSlider.maximumValue = Float(word.count-1)
        pageSlider.value = Float(page)
        if favorites[page] {
            starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        }
    }
    

    @IBAction func back(_ sender: Any) {
        if menu == "즐겨찾기" {
            let defaults = UserDefaults.standard
            var count: Int = 0
            for i in 1...5 {
                do {
                    var temp: String? = defaults.string(forKey: "JLPT\(i)favorites")
                    if temp != nil {
                        for j in 0..<temp!.count {
                            if temp![temp!.index(temp!.startIndex, offsetBy: j)] == "1" {
                                if !favorites[count] {
                                    temp!.remove(at: temp!.index(temp!.startIndex, offsetBy: j))
                                    temp!.insert("0", at: temp!.index(temp!.startIndex, offsetBy: j))
                                    
                                    defaults.set(String(temp!), forKey: "JLPT\(i)favorites")
//                                    print(i)
//                                    print(String(temp!))
                                }
                                count = count + 1
                            }
                        }
                    }
                }
            }
        } else {
            let defaults = UserDefaults.standard
            defaults.set(String(page), forKey: "\(menu)page")
        }
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func beforeOnClick(_ sender: Any) {
        if page != 0 {
            page = page - 1
            wordLabel.text = word[page]
            pageLabel.text = String(page+1)
            meanButton.setTitle("뜻 보기", for: .normal)
            pageSlider.value = Float(page)
            if favorites[page] {
                starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            }
            isShowingMean = false
        }
    }
    @IBAction func afterOnClick(_ sender: Any) {
        if page != word.count-1 {
            page = page + 1
            wordLabel.text = word[page]
            pageLabel.text = String(page+1)
            meanButton.setTitle("뜻 보기", for: .normal)
            pageSlider.value = Float(page)
            if favorites[page] {
                starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            }
            isShowingMean = false
        }
    }
    @IBAction func starOnClick(_ sender: Any) {
        if favorites[page] {
            starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        } else {
            starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        }
        favorites[page] = !favorites[page]
        if menu == "즐겨찾기" {
//            let defaults = UserDefaults.standard
//            var tempPage = page
//            for i in 1...5 {
//                do {
//                    var temp: String? = defaults.string(forKey: "JLPT\(i)favorites")
//                    if temp != nil {
//                        for j in 0..<temp!.count {
//                            if temp![temp!.index(temp!.startIndex, offsetBy: j)] == "1" {
//                                if tempPage == 0 {
//                                    temp!.remove(at: temp!.index(temp!.startIndex, offsetBy: j))
//                                    if favorites[page] {
//                                        temp!.insert("1", at: temp!.index(temp!.startIndex, offsetBy: j))
//                                    } else {
//                                        temp!.insert("0", at: temp!.index(temp!.startIndex, offsetBy: j))
//                                    }
//                                    defaults.set(String(temp!), forKey: "JLPT\(i)favorites")
//                                    print(i)
//                                    print(String(temp!))
//                                    return
//                                }
//                                tempPage = tempPage - 1
//                            }
//                        }
//                    }
//                }
//            }
        } else {
            var temp = ""
            for i in favorites {
                if i {
                    temp.append("1")
                } else {
                    temp.append("0")
                }
            }
            let defaults = UserDefaults.standard
            defaults.set(String(temp), forKey: "\(menu)favorites")
        }
        
    }
    @IBAction func meanOnClick(_ sender: Any) {
        if isShowingMean {
            meanButton.setTitle("뜻 보기", for: .normal)
            isShowingMean = !isShowingMean
        } else {
            meanButton.setTitle(mean[page], for: .normal)
            isShowingMean = !isShowingMean
        }
        
    }
    @IBAction func pageSliderChanged(_ sender: UISlider) {
        page = Int(sender.value)
        wordLabel.text = word[page]
        pageLabel.text = String(page+1)
        meanButton.setTitle("뜻 보기", for: .normal)
        if favorites[page] {
            starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        }
        isShowingMean = false
    }
    
}
