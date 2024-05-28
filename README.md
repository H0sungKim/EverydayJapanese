# 매일 일본어

[Download Link (AppStore)](https://apps.apple.com/kr/app/id6479572744)

## Files

* [JapaneseBenkyo](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo)
  * [JapaneseBenkyo](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo)
    * [Main](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Main)<br>일본어 단어장, 일본어 한자 메뉴 화면이다.
      * [MainViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Main/MainViewController.swift)
      * [Main.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Main/Main.storyboard)
    * [IndexTableViewCell](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/IndexTableViewCell)<br>거의 모든 화면에서 사용되는 목차 TableView의 Cell이다.
      * [IndexTableViewCell.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/IndexTableViewCell/IndexTableViewCell.swift)
      * [IndexTableViewCell.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/IndexTableViewCell/IndexTableViewCell.storyboard)
    * [Vocabulary](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary)
      * [Vocabulary.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/Vocabulary.swift)<br>Vocabulary와 VocabularyForCell을 정의해놓은 파일이다.<br>struct Vocabulary는 단어, 발음, 뜻을 가지고 있다.<br>VocabularyForCell은 Vocabulary와 음 보기, 뜻 보기, 즐겨찾기가 되어있는지를 저장해놓은 변수를 갖고 있다.
      * [Vocabulary](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/Vocabulary)<br>
      단어 난이도를 고를 수 있는 화면이다.
        * [VocabularyViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/Vocabulary/VocabularyViewController.swift)
        * [Vocabulary.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/Vocabulary/Vocabulary.storyboard)
      * [VocabularyDay](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyDay)<br>
      Day 몇의 단어를 공부할지 고를 수 있는 화면이다.
        * [VocabularyDayViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyDay/VocabularyDayViewController.swift)
        * [VocabularyDay.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyDay/VocabularyDay.storyboard)
      * [VocabularyStudy](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyStudy)<br>
      단어 공부를 할 수 있는 화면이다.
        * [VocabularyStudyViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyStudy/VocabularyStudyViewController.swift)
        * [VocabularyStudy.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyStudy/VocabularyStudy.storyboard)
      * [VocabularyTest](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTest)<br>
      암기한 단어들을 테스트할 수 있는 화면이다.
        * [VocabularyTestViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTest/VocabularyTestViewController.swift)
        * [VocabularyTest.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTest/VocabularyTest.storyboard)
      * [VocabularyTestResult](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTestResult)<br>
      테스트의 결과를 보여주는 화면이다. 틀린 단어를 다시 테스트할 수도 있다.
        * [VocabularyTestResultViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTestResult/VocabularyTestResultViewController.swift)
        * [VocabularyTestResult.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTestResult/VocabularyTestResult.storyboard)
      * [VocabularyTableViewCell](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell)<br>
        단어 암기 TableView에 사용되는 Cell에 관련된 폴더이다.
        * [VocabularyTableViewHandler.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell/VocabularyTableViewHandler.swift)<br>
        단어 암기 TableView의 Delegate와 DataSource를 구현한 파일이다.
        * [VocabularyTableViewCell.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell/VocabularyTableViewCell.swift)
        * [VocabularyTableViewCell.xib](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell/VocabularyTableViewCell.xib)
    * [Kanji](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji)
      * [Kanji.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/Kanji.swift)<br>Kanji와 KanjiForCell을 정의해놓은 파일이다.<br>struct Kanji는 칸지(일본 신자체 한자), 한자(한국 정자체 한자), 일본 음, 일본 훈, 한국 음훈, 한자 활용 예시 단어들을 가지고 있다.<br>KanjiForCell은 Kanji와 한국 정자체 보기, 일본 음 보기, 일본 훈 보기, 한국 음훈 보기, 한자 활용 예시 단어들 보기, 즐겨찾기가 되어있는지를 저장해놓은 변수를 갖고 있다.
      * [Kanji](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/Kanji)<br>
      한자 난이도를 고를 수 있는 화면이다.
        * [KanjiViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/Kanji/KanjiViewController.swift)
        * [Kanji.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/Kanji/Kanji.storyboard)
      * [KanjiDay](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiDay)<br>
      Day 몇의 한자를 공부할지 고를 수 있는 화면이다.
        * [KanjiDayViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiDay/KanjiDayViewController.swift)
        * [KanjiDay.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiDay/KanjiDay.storyboard)
      * [KanjiStudy](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiStudy/KanjiStudyViewController.swift)<br>
      한자 공부를 할 수 있는 화면이다.
        * [KanjiStudyViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiStudy/KanjiStudyViewController.swift)
        * [KanjiStudy.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiStudy/KanjiStudy.storyboard)
      * [KanjiTest](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTest)<br>
      암기한 한자들을 테스트할 수 있는 화면이다.
        * [KanjiTestViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTest/KanjiTestViewController.swift)
        * [KanjiTest.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTest/KanjiTest.storyboard)
      * [KanjiTestResult](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTestResult)<br>
      테스트의 결과를 보여주는 화면이다. 틀린 한자를 다시 테스트할 수도 있다.
        * [KanjiTestResultViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTestResult/KanjiTestResultViewController.swift)
        * [KanjiTestResult.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTestResult/KanjiTestResult.storyboard)
      * [KanjiTableViewCell](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell)<br>
      한자 암기 TableView에 사용되는 Cell에 관련된 폴더이다.
        * [KanjiTableViewHandler.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/KanjiTableViewHandler.swift)<br>
        단어 암기 TableView의 Delegate와 DataSource를 구현한 파일이다.
        * [KanjiTableViewCell.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/KanjiTableViewCell.swift)
        * [KanjiTableViewCell.xib](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/KanjiTableViewCell.xib)<br>
        Expandable한 Cell이다.
        * [ExpandableAreaView.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/ExpandableAreaView.swift)
        * [ExpandableAreaView.xib](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/ExpandableAreaView.xib)<br>
        한자 활용 예시 단어를 표시할 label을 담고 있는 view이다. KanjiTableViewCell의 StackView에 예시 단어 개수만큼 들어간다.
    * [Extension](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Extension)
      * [UIViewController+Ext.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Extension/UIViewController%2BExt.swift)<br>
      모든 Scene들을 Enum으로 관리한다.
      * [UINavigationController+Ext.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Extension/UINavigationController%2BExt.swift)<br>
      가장 최근 ViewController를 없애고 새로운 ViewController를 추가하는 replace함수를 구현했다.<br>이는 TestResult Scene에서 틀린 단어 다시 테스트하기를 눌렀을 때 TestResult에서 TestView로 Replace될 때 사용된다.
      * [UIStackView+Ext.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Extension/UIStackView%2BExt.swift)<br>
      StackView를 한번에 비우는 기능의 함수를 구현했다.<br>이는 ExpandableCell에서 사용된다.
    * [Singleton](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Singleton)
      * [JSONManager.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Singleton/JSONManager.swift)<br>
      JSON 데이터를 Kanji, KanjiForCell, Vocabulary, VocabularyForCell로 변환하거나<br>
      Kanji, KanjiForCell, Vocabulary, VocabularyForCell를 JSON 데이터로 변환한다.
      * [TTSManager.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Singleton/TTSManager.swift)<br>
      일본어 발음을 들려주는 TTS를 실행한다.
      * [UserDefaultManager.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Singleton/UserDefaultManager.swift)<br>
      즐겨찾기한 단어들, 학습 진행도를 UserDefault에 저장한다.
      * [CommonConstant.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Singleton/CommonConstant.swift)
      프로젝트에서 공통적으로 사용하는 상수 값을 관리한다.
    * [res](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/res)
      * []()
      * []()
    * [AppDelegate.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/AppDelegate.swift)
    * [Assets.xcassets](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Assets.xcassets)
    * [Base.lproj](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo/Base.lproj)
      * [LaunchScreen.storyboard](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Base.lproj/LaunchScreen.storyboard)<br>
      스플래시뷰이다.
    * [Info.plist](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Info.plist)
  * [JapaneseBenkyoTests](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyoTests)
  * [JapaneseBenkyoUITests](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyoUITests)
  * [JapaneseBenkyo.xcodeproj](https://github.com/H0sungKim/Vocabulary/tree/main/JapaneseBenkyo/JapaneseBenkyo.xcodeproj)
* [Image](https://github.com/H0sungKim/Vocabulary/tree/main/Image)<br>
AppStore에 올린 미리보기 이미지이다.

## Ideas

앱의 대부분의 화면은 UITableView를 활용하여 구성하고 있다.<br>
3000개 정도의 단어나 150 정도의 Days를 다뤄야 하기 때문에 아래와 같은 코드로 reusableCell을 이용하여 최적화해주었다.<br>

### [VocabularyTableViewCell.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell/VocabularyTableViewCell.swift)<br>
VocabularyTableViewCell은 그저 껍데기일 뿐이다. IBOutlet변수들과 IBAction함수들을 연결만 해주었다.<br>
```swift
// VocabularyTableViewCell.swift

import UIKit

class VocabularyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbWord: UILabel!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var lbSound: UILabel!
    @IBOutlet weak var btnMeaning: UIButton!
    @IBOutlet weak var lbMeaning: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    var onClickSound: ((_ sender: UIButton) -> Void)?
    var onClickMeaning: ((_ sender: UIButton) -> Void)?
    var onClickBookmark: ((_ sender: UIButton) -> Void)?
    var onClickPronounce: ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMeaning.titleLabel?.textAlignment = .center
        lbWord.adjustsFontSizeToFitWidth = true
        btnSound.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func onClickSound(_ sender: UIButton) {
        onClickSound?(sender)
    }
    @IBAction func onClickMeaning(_ sender: UIButton) {
        onClickMeaning?(sender)
    }
    @IBAction func onClickBookmark(_ sender: UIButton) {
        onClickBookmark?(sender)
    }
    @IBAction func onClickPronounce(_ sender: UIButton) {
        onClickPronounce?(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
```
<br>

### [VocabularyTableViewHandler.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTableViewCell/VocabularyTableViewHandler.swift)<br>
VocabularyTableViewHandler가 실질적인 알맹이다. VocabularyTableViewCell에서 연결해준 IBOutlet변수들과 IBAction함수들을 활용하여 실질적으로 구현하였다.<br>
VocabularyTableView는 여러번 사용되기 때문에 VocabularyTableViewHandler.swift파일을 만들어 UITableViewDataSoure, UITableViewDelegate와 VocabularyTable 관련 로직들을 따로 빼내주었다.
```swift
// VocabularyTableViewHandler.swift
...
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: VocabularyTableViewCell
    let vocabularyForCell: VocabularyForCell = vocabulariesForCell[indexPath.row]
    if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: VocabularyTableViewCell.self), for: indexPath) as? VocabularyTableViewCell {
        cell = reusableCell
    } else {
        let objectArray = Bundle.main.loadNibNamed(String(describing: VocabularyTableViewCell.self), owner: nil, options: nil)
        cell = objectArray![0] as! VocabularyTableViewCell
    }
    cell.onClickSound = { [weak self] sender in
        self?.onClickSound(cell, sender, vocabularyForCell: vocabularyForCell)
    }
    cell.onClickMeaning = { [weak self] sender in
        self?.onClickMeaning(cell, sender, vocabularyForCell: vocabularyForCell)
    }
    cell.onClickBookmark = { [weak self] sender in
        self?.onClickBookmark(cell, sender, vocabularyForCell: vocabularyForCell)
    }
    cell.onClickPronounce = { [weak self] sender in
        self?.onClickPronounce(cell, sender, vocabularyForCell: vocabularyForCell)
    }
    
    initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
    
    return cell
}
...
```
<br>

### [VocabularyTestResultViewController.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Vocabulary/VocabularyTestResult/VocabularyTestResultViewController.swift)<br>
VocabularyTable 사용 예시
```swift
// VocabularyTestResultViewController.swift

import UIKit

class VocabularyTestResultViewController: UIViewController {
    ...
    private var vocabularyTableDataSource: VocabularyTableViewHandler?
    ...
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vocabularyTableDataSource = VocabularyTableViewHandler(vocabulariesForCell: vocabulariesForCell)
        
        tableView.delegate = vocabularyTableDataSource
        tableView.dataSource = vocabularyTableDataSource
        tableView.rowHeight = CGFloat(CommonConstant.cellSize)
        tableView.register(UINib(nibName: String(describing: VocabularyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VocabularyTableViewCell.self))
        ...
```
<br>

---

<br>

ExpandableCell은 매일 일본어 개발 중 가장 어려웠던 부분이었다.<br>
한자 활용 예시 단어 개수에 따라 유동적으로 높이가 변해야하고 reusableCell을 사용할 수 있어야 했기 때문에 적절한 방법을 찾기 힘들었다.<br>
라이브러리, NSLayoutConstraint 활용, cell insert 등 여러가지 방법들을 시도했지만 실패했다.

<img width="574" alt="스크린샷 2024-05-14 16 06 36" src="https://github.com/H0sungKim/Vocabulary/assets/78355442/f0cddada-ceb2-4d17-8b6c-4c668a1db700"><br>

### [KanjiTableViewHandler.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/KanjiTableViewHandler.swift)<br>
```swift
// KanjiTableViewHandler.swift
...
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
...
private func onClickExpand(_ cell: KanjiTableViewCell, _ sender: UIButton, kanjiForCell: KanjiForCell, indexPath: IndexPath) {
    kanjiForCell.isExpanded = !kanjiForCell.isExpanded
    initializeCell(cell: cell, kanjiForCell: kanjiForCell)
    tableView.reloadRows(at: [indexPath], with: .automatic)
}
...
```
<img width="741" alt="스크린샷 2024-05-14 16 14 46" src="https://github.com/H0sungKim/Vocabulary/assets/78355442/5b4810c2-2a4f-42c7-8400-11447e1e2b35"><br>
기존 KanjiTableViewCell 밑에 Intrinsic Size를 Placeholder로 설정한 StackView를 추가하고 cellHeight도 autometicDimension으로 설정하였다. 확장 버튼이 눌리면 stackView에 활용 단어 예시들을 추가해주고 reloadRows를 한다. 그러면 알아서 높이를 새롭게 계산하여 애니메이션과 함께 reload되기 때문에 ExpandableCell이 된다.<br><br>
이 방법도 문제가 아예 없지는 않았다. 높이 계산이 다른 작업보다 오래 걸리는지, 버튼을 누르고 Expand 되기 전 잠시동안 활용 예시 단어들이 밑바닥에 겹쳐서 깔려있는 것이 보이는 이슈가 있었다.
### [KanjiTableViewHandler.swift](https://github.com/H0sungKim/Vocabulary/blob/main/JapaneseBenkyo/JapaneseBenkyo/Kanji/KanjiTableViewCell/ExpandableAreaView.swift)<br>
```swift
// ExpandableAreaView.swift
...
lbTitle.clipsToBounds = true
...
```
clipsToBounds를 통해 삐져나오는 부분을 invisible하게 만들어주어 해결했다.
<br>

---

<br>