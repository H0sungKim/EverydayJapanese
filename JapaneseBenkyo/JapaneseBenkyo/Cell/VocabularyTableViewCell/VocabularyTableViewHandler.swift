//
//  VocabularyTableDataSource.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/11/24.
//

import UIKit
import Combine
import SkeletonView

class VocabularyTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var vocabulariesForCell: [VocabularyForCell]
    private var bookmark: Set<Vocabulary> = []
    var onReload: ((_ indexPath: IndexPath)->Void)?
    var showSkeleton: ((_ indexPath: IndexPath)->Void)?
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(vocabulariesForCell: [VocabularyForCell]) {
        self.vocabulariesForCell = vocabulariesForCell
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
            bookmark = JSONManager.shared.decodeJSONtoVocabularySet(jsonData: jsonData)
        }
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isBookmark = bookmark.contains(vocabularyForCell.vocabulary)
        }
        super.init()
    }
    
    func shuffleVocabularies() {
        vocabulariesForCell.shuffle()
    }
    
    func setVisibleAll() {
        // all vocabulariesForCell is visible
        if !vocabulariesForCell.contains(where: { !$0.isVisible }) {
            for vocabularyForCell in vocabulariesForCell {
                vocabularyForCell.isVisible = false
            }
        } else {
            for vocabularyForCell in vocabulariesForCell {
                vocabularyForCell.isVisible = true
            }
        }
    }
    
    func addBookmarkAll() {
        bookmark.formUnion(Set(vocabulariesForCell.map { $0.vocabulary }))
        UserDefaultManager.shared.vocabularyBookmark = JSONManager.shared.encodeVocabularyJSON(vocabularies: bookmark)
        for vocabularyForCell in vocabulariesForCell {
            vocabularyForCell.isBookmark = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulariesForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VocabularyTableViewCell
        let vocabularyForCell: VocabularyForCell = vocabulariesForCell[indexPath.row]
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: VocabularyTableViewCell.self), for: indexPath) as? VocabularyTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: VocabularyTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! VocabularyTableViewCell
        }
        
        cell.onClickBookmark = { [weak self] sender in
            self?.onClickBookmark(cell, sender, vocabularyForCell: vocabularyForCell)
        }
        cell.onClickPronounce = { [weak self] sender in
            self?.onClickPronounce(cell, sender, vocabularyForCell: vocabularyForCell)
        }
        cell.onClickExpand = { [weak self] sender in
            self?.onClickExpand(cell, sender, vocabularyForCell: vocabularyForCell, indexPath: indexPath)
        }
        
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? VocabularyTableViewCell {
            vocabulariesForCell[indexPath.row].isVisible = !vocabulariesForCell[indexPath.row].isVisible
            initializeCell(cell: cell, vocabularyForCell: vocabulariesForCell[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func onClickBookmark(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        if vocabularyForCell.isBookmark {
            bookmark.remove(vocabularyForCell.vocabulary)
        } else {
            bookmark.insert(vocabularyForCell.vocabulary)
        }
        vocabularyForCell.isBookmark = !vocabularyForCell.isBookmark
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        UserDefaultManager.shared.vocabularyBookmark = JSONManager.shared.encodeVocabularyJSON(vocabularies: bookmark)
    }
    private func onClickPronounce(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell) {
        TTSManager.shared.play(vocabulary: vocabularyForCell.vocabulary)
    }
    private func onClickExpand(_ cell: VocabularyTableViewCell, _ sender: UIButton, vocabularyForCell: VocabularyForCell, indexPath: IndexPath) {
        vocabularyForCell.isExpanded = !vocabularyForCell.isExpanded
        initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
        onReload?(indexPath)
        CommonRepository.shared.getSentence(word: vocabularyForCell.vocabulary.word)
            .sink(receiveCompletion: { error in
                NSLog("\(error)")
            }, receiveValue: { [weak self] tatoebaModel in
                vocabularyForCell.exampleSentence = tatoebaModel
                self?.initializeCell(cell: cell, vocabularyForCell: vocabularyForCell)
                self?.onReload?(indexPath)
            })
            .store(in: &cancellable)
    }
    
    private func initializeCell(cell: VocabularyTableViewCell, vocabularyForCell: VocabularyForCell) {
        let wordString = NSMutableAttributedString(string: vocabularyForCell.vocabulary.word)
        wordString.addAttribute(.languageIdentifier, value: "ja", range: NSRange(location: 0, length: vocabularyForCell.vocabulary.word.count))
        cell.lbWord.attributedText = wordString
        
        cell.lbSound.text = vocabularyForCell.isVisible ? vocabularyForCell.vocabulary.sound : ""
        cell.lbMeaning.text = vocabularyForCell.isVisible ? vocabularyForCell.vocabulary.meaning : ""
        
        cell.btnBookmark.setImage(UIImage(systemName: vocabularyForCell.isBookmark ? "star.fill" : "star"), for: .normal)
        
        cell.btnExpand.setImage(UIImage(systemName: vocabularyForCell.isExpanded ? "chevron.up" : "chevron.down"), for: .normal)
        cell.stackView.clearSubViews()
        if vocabularyForCell.isExpanded, let expandableAreaView = Bundle.main.loadNibNamed(String(describing: ExampleSentenceView.self), owner: nil, options: nil)?.first as? ExampleSentenceView {
            cell.stackView.addArrangedSubview(expandableAreaView)
            guard let exampleSentence = vocabularyForCell.exampleSentence else {
                
                expandableAreaView.lbSentence.showAnimatedGradientSkeleton(transition: .crossDissolve(0))
                
                return
            }
            expandableAreaView.onClickLink = {
                if exampleSentence.id == 0 {
                    return
                }
                guard let url = URL(string: "https://tatoeba.org/ko/sentences/show/\(exampleSentence.id)"), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            expandableAreaView.lbSentence.attributedText = getRubyAnnotationString(html: exampleSentence.html, sentence: exampleSentence.text)
            expandableAreaView.lbSentence.hideSkeleton(transition: .crossDissolve(0))
        }
    }
    
    private func getRubyAnnotationString(html: String, sentence: String) -> NSAttributedString? {
        let nsString = sentence as NSString
        let attributedString = NSMutableAttributedString(string: sentence)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: attributedString.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineHeightMultiple = 1.5

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        let regexExtractRuby = #"<ruby>.*?</ruby>"#

        guard let rubyRegex = try? NSRegularExpression(pattern: regexExtractRuby, options: []) else { return nil }
            
        let rubyMatches = rubyRegex.matches(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))
        
        for rubyMatch in rubyMatches {
            guard let rubyRange = Range(rubyMatch.range, in: html) else { continue }
            let rubyText = String(html[rubyRange])
            let regexExtractFurigana = #"<ruby>(.*?)<rp>\（</rp><rt>(.*?)</rt><rp>\）</rp></ruby>"#
            guard let furiganaRegex = try? NSRegularExpression(pattern: regexExtractFurigana, options: []) else { continue }
            
            guard let match = furiganaRegex.firstMatch(in: rubyText, options: [], range: NSRange(location: 0, length: rubyText.utf16.count)) else { continue }
            let originalRange = Range(match.range(at: 1), in: rubyText)!
            let furiganaRange = Range(match.range(at: 2), in: rubyText)!
            
            let originalText = String(rubyText[originalRange])
            let furiganaText = String(rubyText[furiganaRange])
            
            let rubyAttribute: [CFString: Any] =  [
                kCTRubyAnnotationSizeFactorAttributeName: 0.5,
                kCTForegroundColorAttributeName: UIColor.secondaryLabel
            ]
            let rubyAnnotation = CTRubyAnnotationCreateWithAttributes(.auto, .auto, .before, furiganaText as CFString, rubyAttribute as CFDictionary)
            let rubyAnnotationRange = nsString.range(of: originalText)
            attributedString.addAttributes([kCTRubyAnnotationAttributeName as NSAttributedString.Key: rubyAnnotation], range: rubyAnnotationRange)
        }
        return attributedString
    }
}
