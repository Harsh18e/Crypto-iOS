//
//  ErrorModel.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

enum NetworkError: Error {
    case unableToParse
    case apiError
    case BadURL
}

enum LoginType {
    case email
    case google
    case signUp
}

enum UserType {
    case firebaseUser(User)
    case googleUser(GIDGoogleUser)
}
