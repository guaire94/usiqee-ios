//
//  NewsDetailsTextCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

class NewsDetailsTextCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsTextCell"
        fileprivate static let kern: CGFloat = -0.33
        fileprivate static let lineHeightMultiple: CGFloat = 1.11
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(content: String) {
        guard let formattedItems = parse(text: content) else {
            set(text: content)
            return
        }
        
        let formats = format(text: content, with: formattedItems)
        set(text: formats.0, items: formattedItems.compactMap { $0.type }, ranges:formats.1)
    }
    
    // MARK: - Private
    
    private func set(text: String, items: [FormattedItemType] = [], ranges: [NSRange] = []) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.lineHeightMultiple
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.kern: Constants.kern,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: Fonts.NewsDetails.Text.content,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        for (i, range) in ranges.enumerated() {
            let attributes: [NSAttributedString.Key: Any]
            switch items[i] {
            case .link(url: let url):
                attributes = [.link: url, .font: Fonts.NewsDetails.Text.url]
            case .bold:
                attributes = [.font: Fonts.NewsDetails.Text.contentBold]
            case .italic:
                attributes = [.font: Fonts.NewsDetails.Text.contentItalic]
            case .underline:
                attributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
            }
            attributedText.addAttributes(attributes, range: range)
        }
        
        contentTextView.attributedText = attributedText

        contentHeightConstraint.constant = contentTextView.contentSize.height
        layoutIfNeeded()
    }
    
    private func format(text: String, with formattedItems: [FormattedItem]) ->  (String, [NSRange]) {
        var result: String = text
        var finalRanges: [NSRange] = []
        
        var offset: Int = 0
        for formattedItem in formattedItems {
            switch formattedItem.type {
            case let .link(url: url):
                let rangeLength = formattedItem.range.length + url.absoluteString.count + 4
                let nsrange = NSRange(location: formattedItem.range.location-1-offset, length: rangeLength)
                guard let range = Range(nsrange, in: text) else {
                    continue
                }
                result.replaceSubrange(range, with: formattedItem.text)
                
                let rangeLocation: Int = formattedItem.range.location-1-offset
                offset += url.absoluteString.count+4
                finalRanges.append(NSRange(location:rangeLocation, length: formattedItem.range.length))
            case .bold,
                 .italic,
                 .underline:
                let rangeLength = formattedItem.range.length + 4
                let nsrange = NSRange(location: formattedItem.range.location-2-offset, length: rangeLength)
                guard let range = Range(nsrange, in: text) else {
                    continue
                }
                result.replaceSubrange(range, with: formattedItem.text)
                
                let rangeLocation: Int = formattedItem.range.location-2-offset
                offset += 4
                finalRanges.append(NSRange(location:rangeLocation, length: formattedItem.range.length))
            }
        }
        
        return (result, finalRanges)
    }
    
    private func parse(text: String) -> [FormattedItem]? {
        let texts = matches(for: "(?<=\\[)[^\\[\\])]+(?=\\]\\{)", in: text)
        let urls = matches(for: "(?<=\\{)[^\\{\\})]+(?=\\})", in: text)
        let bolds = matches(for: "(?<=\\*\\*)[^\\*]+(?=\\*\\*)", in: text)
        let italics = matches(for: "(?<=__)[^_]+(?=__)", in: text)
        let underlines = matches(for: "(?<=--)[^-]+(?=--)", in: text)
        if texts.isEmpty, bolds.isEmpty, italics.isEmpty, underlines.isEmpty { return nil }
        
        var result: [FormattedItem] = []
        for (index, value) in texts.enumerated() {
            guard let url = URL(string: urls[index].0) else {
               continue
            }
            result.append(FormattedItem(text: value.0, type: .link(url: url), range: value.1))
        }
        
        let finalBolds = removeUseless(expressions: bolds)
        for value in finalBolds {
            result.append(FormattedItem(text: value.0, type: .bold, range: value.1))
        }
        
        let finalItalics = removeUseless(expressions: italics)
        for value in finalItalics {
            result.append(FormattedItem(text: value.0, type: .italic, range: value.1))
        }
        
        let finalUnderlines = removeUseless(expressions: underlines)
        for value in finalUnderlines {
            result.append(FormattedItem(text: value.0, type: .underline, range: value.1))
        }
        return result.sorted(by: { $0.range.location < $1.range.location })
    }
    
    private func removeUseless(expressions: [(String, NSRange)]) -> [(String, NSRange)] {
        var results: [(String, NSRange)] = []
        if expressions.count > 1 {
            for i in 0..<expressions.count {
                if i % 2 == 0 {
                    results.append(expressions[i])
                }
            }
        } else {
            results = expressions
        }
        return results
    }
    
    private func matches(for regex: String, in text: String) -> [(String, NSRange)] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            
            return results.map {
                (String(text[Range($0.range, in: text)!]), $0.range)
            }
        } catch {
            return []
        }
    }
}

private struct FormattedItem {
    let text: String
    let type: FormattedItemType
    let range: NSRange
}

private enum FormattedItemType {
    case link(url: URL)
    case bold
    case italic
    case underline
}
