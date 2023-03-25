//
//  CoinsTableViewCell.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 02/03/23.
//

import UIKit
import Kingfisher

class CoinsTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var coinShortName: UILabel!
    @IBOutlet weak var coinLogo: UIImageView!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinIndex: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPriceChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ data: Coin, _ index: Int, _ image: UIImage?) {
        
        coinLogo.image = image
        coinShortName.text = data.symbol.uppercased()
        
        if data.priceChangePercentage24H ?? 0 < 0 {
            coinPriceChange.textColor = .red
        } else {
            coinPriceChange.textColor = .systemGreen
        }

        
        coinPrice.text = "$ " + (data.currentPrice.roundedStringWithTwoDecimals())
        coinIndex.text = "\(index+1)"
        coinName.text = data.name
        
        coinPriceChange.text = (data.priceChangePercentage24H?.roundedStringWithTwoDecimals() ?? "0") + " %"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
