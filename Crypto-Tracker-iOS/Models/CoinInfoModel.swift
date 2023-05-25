//
//  CoinInfoModel.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 27/03/23.
//

import Foundation
import UIKit

struct CoinInfo: Codable {
    let id, symbol, name: String
    let description: Description
}

struct Description: Codable {
    let en: String
}

enum DetailBlockType: Int {
    case currentPrice
    case marketCap
    case rank
    case volume
    
    case high24H // 0 
    case low24H
    case priceChange24H
    case capchange24H
    case blockTime
    case hashingAlgorithm
    
    var stringValue: String {
        switch self {
        case .currentPrice:
            return "Current Price"
        case .marketCap:
            return "Market Cap"
        case .rank:
            return "Rank"
        case .volume:
            return "Volume"
        case .high24H:
            return "High 24H"
        case .low24H:
            return "Low 24H"
        case .priceChange24H:
            return "Price Change 24H"
        case .capchange24H:
            return "Cap Change 24H"
        case .blockTime:
            return "Block Time"
        case .hashingAlgorithm:
            return "Hashing Algorithm"
        }
    }
}
