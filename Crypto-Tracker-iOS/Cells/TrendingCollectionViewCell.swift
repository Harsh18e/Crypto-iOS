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
    @IBOutlet weak var containerView: CustomUIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ data: Coin, _ image: UIImage?) {
        
        coinLogo.image = image
        coinShortName.text = data.symbol.uppercased()
        
        var priceColor = UIColor.red.cgColor
        if data.priceChangePercentage24H ?? 0 < 0 {
            priceChangeLabel.textColor = .red
        } else {
            priceChangeLabel.textColor = .systemGreen
            priceColor = UIColor.green.cgColor
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.2) // set the starting point to the left side of the view
        gradientLayer.endPoint = CGPoint(x: 8, y: 2)
        gradientLayer.colors = [UIColor.nightGray.cgColor, priceColor] // set the colors for the gradient
        containerView.layer.insertSublayer(gradientLayer, at: 0) // add the gradient layer to the view's layer
        
        priceLabel.text = "$ " + (data.currentPrice.convertToShortString())
        coinName.text = data.name
        priceChangeLabel.text = (data.priceChangePercentage24H?.convertToShortString() ?? "0") + " %"
    }

}
