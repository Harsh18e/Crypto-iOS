//
//  ErrorModel.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation

enum NetworkError: Error {
    case unableToParse
    case apiError
    case BadURL
}

