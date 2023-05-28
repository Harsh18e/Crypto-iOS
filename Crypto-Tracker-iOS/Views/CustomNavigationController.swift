//
//  CustomNavigationController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 31/03/23.
//

import Foundation
import UIKit
import SwiftUI

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set custom navigation bar appearance
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .lightPink
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.lightPink
        ]
    }

}
