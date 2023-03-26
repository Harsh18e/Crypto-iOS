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
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ viewModel: PrimaryViewModel?, _ index: Int) {
        
        guard let data = viewModel?.getCoinData(index) else {
            return
        }
        
        coinLogo.image = viewModel?.getImageAtId(data.id)
        coinShortName.text = data.symbol.uppercased()
        
        var priceColor = UIColor.red.cgColor
        if data.priceChangePercentage24H ?? 0 < 0 {
            coinPriceChange.textColor = .red
        } else {
            coinPriceChange.textColor = .systemGreen
            priceColor = UIColor.green.cgColor
        }
        mainView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainView.bounds
        gradientLayer.colors = [UIColor.nightGray.cgColor, priceColor] // set the colors for the gradient
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.2) // set the starting point to the left side of the view
        gradientLayer.endPoint = CGPoint(x: 8, y: 2) // set the ending point to the right side of the view
        mainView.layer.insertSublayer(gradientLayer, at: 0) // add the gradient layer to the view's layer
        
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
