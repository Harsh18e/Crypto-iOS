//
//  TrendingCollectionViewCell.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 06/03/23.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var coinLogo: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var coinShortName: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ data: Coin, _ image: UIImage?) {
        
        coinLogo.image = image
        coinShortName.text = data.symbol.uppercased()
        
        if data.priceChangePercentage24H ?? 0 < 0 {
            priceChangeLabel.textColor = .red
        } else {
            priceChangeLabel.textColor = .systemGreen
        }
        priceLabel.text = "$ " + (data.currentPrice.roundedStringWithTwoDecimals())
        coinName.text = data.name
        priceChangeLabel.text = (data.priceChangePercentage24H?.roundedStringWithTwoDecimals() ?? "0") + " %"
    }

}
