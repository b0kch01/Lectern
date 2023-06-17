//
//  BlockStyle.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension Block {
    func hasStyle(_ style: BentoTextStyle) -> Bool {
        switch style {

        case let style as TextStyle:
            return styles?.contains(style) == true

        case let style as ListStyle:
            return self.listStyle == style

        case let style as Alignment:
            return align == style

        default:
            return false
        }
    }

    func addStyle(_ style: BentoTextStyle) {
        switch style {
        case let style as TextStyle:
            if styles == nil { styles = [] }
            styles?.insert(style)
        case let style as Alignment:
            align = style
        case let style as ListStyle:
            listStyle = style
        default:
            return
        }
    }

    func removeStyle(_ style: BentoTextStyle) {
        switch style {
        case let style as TextStyle:
            styles?.remove(style)
        case _ as ListStyle:
            listStyle = nil
        default:
            return
        }
    }
}
