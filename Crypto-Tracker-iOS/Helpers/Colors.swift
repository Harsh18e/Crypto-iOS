//
//  Colors.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 25/03/23.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
            var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexString = hexString.replacingOccurrences(of: "#", with: "")
            
            if hexString.count != 6 {
                return nil
            }
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
}

extension UIColor {
    static let nightGray = UIColor(hex: "#101010", alpha: 1)!
    static let whiteGray = UIColor(hex: "#BEBEBE")!
    static let purpleGray = UIColor(hex: "#220F25")!
    static let maroon = UIColor(hex: "EB408D")!
    static let lightPink = UIColor(hex: "FACFFC")!
}
