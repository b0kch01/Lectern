//
//  Constants.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct URL_K {
    static let endpoint = "localhost:3000"
    static let blurt = endpoint.path("blurt")
    static let practice = endpoint.path("practice")
}

struct CardItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var desc: String
    var isStudy: Bool
}

struct FolderItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var count: Int
    var isStudy: Bool
}

struct Dmy {
    // swiftlint:disable line_length
    static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "

    static let loremSS = "Lorem ipsum dolor sit amet "

    static let loremS = "Lorem ipsum dolor sit amet, consectetur. "

    static let loremL = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. "

    static let loremP = "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. "
}

struct Screen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}


class UIConstants: ObservableObject {

    // Font sizes
    static var largeTitle: CGFloat = 34
    static var title: CGFloat = 28
    static var title2: CGFloat = 22
    static var title3: CGFloat = 20
    static var header: CGFloat = 18
    static var body: CGFloat = 17
    static var callout: CGFloat = 16
    static var subheadline: CGFloat = 15
    static var subhead: CGFloat = 14
    static var footnote: CGFloat = 13
    static var caption: CGFloat = 12

    // Display radius
    static var screenRadius: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let modelToRadius: [String: CGFloat] = [
                "iPhone10,1": 20, // iPhone 8
                "iPhone10,2": 20, // iPhone 8 Plus
                "iPhone10,4": 20, // iPhone 8
                "iPhone10,5": 20, // iPhone 8 Plus
                "iPhone12,8": 20, // iPhone SE 2nd Gen
                "iPhone14,6": 20, // iPhone SE 3rd Gen
                "iPhone10,3": 39, // iPhone X Global
                "iPhone10,6": 39, // iPhone X GSM
                "iPhone11,2": 39, // iPhone XS
                "iPhone11,4": 39, // iPhone XS Max
                "iPhone11,6": 39, // iPhone XS Max Global
                "iPhone11,8": 41.5, // iPhone XR
                "iPhone12,1": 41.5, // iPhone 11
                "iPhone12,3": 39, // iPhone 11 Pro
                "iPhone12,5": 39, // iPhone 11 Pro Max
                "iPhone13,1": 44, // iPhone 12 Mini
                "iPhone13,2": 47.33, // iPhone 12
                "iPhone13,3": 47.33, // iPhone 12 Pro
                "iPhone13,4": 53.33, // iPhone 12 Pro Max
                "iPhone14,2": 47.33, // iPhone 13 Pro
                "iPhone14,3": 53.33, // iPhone 13 Pro Max
                "iPhone14,4": 44, // iPhone 13 Mini
                "iPhone14,5": 47.3, // iPhone 13
                "iPhone14,7": 47.33, // iPhone 14
                "iPhone14,8": 53.33, // iPhone 14 Plus
                "iPhone15,2": 55, // iPhone 14 Pro
                "iPhone15,3": 55  // iPhone 14 Pro Max
            ]

            if let radius = modelToRadius[Device.model()] {
                return radius
            }

            return 18
        } else {
            return 18
        }
    }

    static var screenIsRounded: Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let modelToBool: [String: Bool] = [
                "iPhone10,1": false, // iPhone 8
                "iPhone10,2": false, // iPhone 8 Plus
                "iPhone10,4": false, // iPhone 8
                "iPhone10,5": false, // iPhone 8 Plus
                "iPhone12,8": false, // iPhone SE 2nd Gen
                "iPhone14,6": false, // iPhone SE 3rd Gen
            ]

            if let isRounded = modelToBool[Device.model()] {
                return isRounded
            }

            return true
        } else {
            let modelToBool: [String: Bool] = [
                "iPad6,3": false, // iPad Pro (9.7 inch, WiFi)
                "iPad6,4": false, // iPad Pro (9.7 inch, WiFi+LTE)
                "iPad6,7": false, // iPad Pro (12.9 inch, WiFi)
                "iPad6,8": false, // iPad Pro (12.9 inch, WiFi+LTE)
                "iPad6,11": false, // iPad (2017)
                "iPad6,12": false, // iPad (2017)
                "iPad7,1": false, // iPad Pro 2nd Gen (WiFi)
                "iPad7,2": false, // iPad Pro 2nd Gen (WiFi+Cellular)
                "iPad7,3": false, // iPad Pro 10.5-inch 2nd Gen
                "iPad7,4": false, // iPad Pro 10.5-inch 2nd Gen
                "iPad7,5": false, // iPad 6th Gen (WiFi)
                "iPad7,6": false, // iPad 6th Gen (WiFi+Cellular)
                "iPad7,11": false, // iPad 7th Gen 10.2-inch (WiFi)
                "iPad7,12": false, // iPad 7th Gen 10.2-inch (WiFi+Cellular)
                "iPad8,1": false, // iPad Pro 11 inch 3rd Gen (WiFi)
                "iPad8,2": false, // iPad Pro 11 inch 3rd Gen (1TB, WiFi)
                "iPad8,3": false, // iPad Pro 11 inch 3rd Gen (WiFi+Cellular)
                "iPad8,4": false, // iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)
                "iPad8,5": false, // iPad Pro 12.9 inch 3rd Gen (WiFi)
                "iPad8,6": false, // iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)
                "iPad8,7": false, // iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)
                "iPad8,8": false, // iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)
                "iPad8,9": false, // iPad Pro 11 inch 4th Gen (WiFi)
                "iPad8,10": false, // iPad Pro 11 inch 4th Gen (WiFi+Cellular)
                "iPad8,11": false, // iPad Pro 12.9 inch 4th Gen (WiFi)
                "iPad8,12": false, // iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)
                "iPad11,1": false, // iPad mini 5th Gen (WiFi)
                "iPad11,2": false, // iPad mini 5th Gen
                "iPad11,3": false, // iPad Air 3rd Gen (WiFi)
                "iPad11,4": false, // iPad Air 3rd Gen
                "iPad11,6": false, // iPad 8th Gen (WiFi)
                "iPad11,7": false, // iPad 8th Gen (WiFi+Cellular)
                "iPad12,1": false, // iPad 9th Gen (WiFi)
                "iPad12,2": false // iPad 9th Gen (WiFi+Cellular)
            ]

            if let isRounded = modelToBool[Device.model()] {
                return isRounded
            }

            return true
        }
    }
}

struct Device {
    /// iOS Version
    static let version = UIDevice.current.systemVersion
    /// `VendorID` with `UDID` format
    static let udid: String = (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString)
        .replacingOccurrences(of: "-", with: "42")

    /// Get device model
    static func model() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let modelCode = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return modelCode
    }
}
