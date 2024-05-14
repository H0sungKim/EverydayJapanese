# 매일 일본어

[Download Link (AppStore)](https://apps.apple.com/kr/app/id6479572744)

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