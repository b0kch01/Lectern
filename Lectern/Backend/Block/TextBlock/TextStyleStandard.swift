//
//  TextStyleStandard.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct TextStyleStandard {

    static let PLACEHOLDER = "Notaking is an art~"
    static let INIT = " "

    private static func alignmentConvert(_ align: Alignment) -> NSTextAlignment {
        switch align {
        case .leading:  return .left
        case .center:   return .center
        case .trailing: return .right

        default: return .left
        }
    }

    static func header(_ block: Block) -> NSMutableAttributedString {
        let styles = block.styles ?? []
        let align = block.align ?? .leading

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignmentConvert(align)
        paragraphStyle.lineHeightMultiple = 1.3

        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(
                ofSize: 18,
                weight: UIFont.Weight.semibold
            )
            .withTraits(traits: [
                .traitBold,
                styles.contains(.italic) ? .traitItalic : nil,
            ]),
            .underlineStyle: styles.contains(.underline) ? NSUnderlineStyle.single.rawValue : 0,
            .strikethroughStyle: styles.contains(.strikethrough) ? NSUnderlineStyle.single.rawValue : 0,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.label
        ]

        return NSMutableAttributedString(string: block.text ?? "", attributes: attrs)
    }

    static func body(_ block: Block) -> NSMutableAttributedString {

        let styles = block.styles ?? []
        let align = block.align ?? .leading

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignmentConvert(align)
        paragraphStyle.lineHeightMultiple = 1.3

        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(
                ofSize: 18,
                weight: UIFont.Weight.regular
            )
            .withTraits(traits: [
                styles.contains(.bold) ? .traitBold : nil,
                styles.contains(.italic) ? .traitItalic : nil,
            ]),
            .underlineStyle: styles.contains(.underline) ? NSUnderlineStyle.single.rawValue : 0,
            .strikethroughStyle: styles.contains(.strikethrough) ? NSUnderlineStyle.single.rawValue : 0,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.label.withAlphaComponent(0.5)
        ]

        return NSMutableAttributedString(string: block.text ?? "", attributes: attrs)
    }
}
