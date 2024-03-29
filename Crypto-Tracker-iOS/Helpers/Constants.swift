//
//  Constants.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation

struct Constants {
    
    static let LOGINSTATUS = "isUserLoggedIn"
    static let URL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true"
    static let coinURL = "https://api.coingecko.com/api/v3/coins/"
    static let coinEndpoint = "?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false"
}

