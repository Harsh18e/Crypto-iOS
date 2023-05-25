//
//  DetailsCollectionViewCell.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 25/05/23.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBoutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subtitleSignImage: UIImageView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    private weak var viewModel: PrimaryViewModel?
    
    // MARK: Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(_ coin: Coin?, type: DetailBlockType?, _ vm: PrimaryViewModel?) {
        
        self.viewModel = vm
        guard let type = type, let coin = coin else {return}
        
        switch type {
        case .currentPrice:
            headingLabel.text = "Current Price"
            titleLabel.text = "$ " + (coin.currentPrice.convertToShortString())
            subtitleLabel.text = (coin.priceChangePercentage24H?.convertToShortString() ?? "0") + " %"
            
            if coin.priceChangePercentage24H ?? 0 < 0 {
                subtitleLabel.textColor = .red
                subtitleSignImage.setFlippedSystemSymbolImage(systemSymbol: "triangle.fill", tintColor: .maroon)
            } else {
                subtitleLabel.textColor = .green
            }
            
        case .marketCap:
            headingLabel.text = "Market Cap"
            titleLabel.text = "$ " + (coin.marketCap?.convertToShortString() ?? "")
            subtitleLabel.text = (coin.marketCapChangePercentage24H?.convertToShortString() ?? "0") + " %"
            
            if coin.marketCapChangePercentage24H ?? 0 < 0 {
                subtitleLabel.textColor = .red
                subtitleSignImage.setFlippedSystemSymbolImage(systemSymbol: "triangle.fill", tintColor: .maroon)
            } else {
                subtitleLabel.textColor = .green
            }
        case .rank:
            headingLabel.text = "Rank"
            titleLabel.text = (viewModel?.getPriceRank(coin.id)) ?? String(describing: coin.marketCapRank?.convertToShortString() ?? "N/A")
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
        case .volume:
            headingLabel.text = "Volume"
            titleLabel.text = String(describing: coin.totalVolume?.convertToShortString() ?? "N/A" )
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
            
        case .high24H:
            headingLabel.text = "High 24H"
            titleLabel.text = String(describing: coin.high24H?.convertToShortString() ?? "N/A")
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
        case .low24H:
            headingLabel.text = "Low 24H"
            titleLabel.text = String(describing: coin.low24H?.convertToShortString() ?? "N/A")
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
            
        case .priceChange24H:
            headingLabel.text = "Price Change 24H"
            titleLabel.text = String(describing: coin.priceChange24H?.convertToShortString() ?? "N/A")
            subtitleLabel.text = (coin.priceChangePercentage24H?.convertToShortString() ?? "0") + " %"
            
            if coin.priceChangePercentage24H ?? 0 < 0 {
                subtitleLabel.textColor = .red
                subtitleSignImage.setFlippedSystemSymbolImage(systemSymbol: "triangle.fill", tintColor: .maroon)
            } else {
                subtitleLabel.textColor = .green
            }
            
        case .capchange24H:
            headingLabel.text = "Market Cap Change 24H"
            titleLabel.text = String(describing: coin.marketCapChange24H?.convertToShortString() ?? "N/A")
            subtitleLabel.text = (coin.marketCapChangePercentage24H?.convertToShortString() ?? "0") + " %"
            
            if coin.marketCapChangePercentage24H ?? 0 < 0 {
                subtitleLabel.textColor = .red
                subtitleSignImage.setFlippedSystemSymbolImage(systemSymbol: "triangle.fill", tintColor: .maroon)
            } else {
                subtitleLabel.textColor = .green
            }
            
        case .blockTime:
            headingLabel.text = "Block Time"
            titleLabel.text = String(describing: coin.blockTime?.convertToShortString() ?? "N/A")
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
            
        case .hashingAlgorithm:
            headingLabel.text = "Hashing Algorithm"
            titleLabel.text = coin.hashingAlgorithm ?? "N/A"
            subtitleLabel.isHidden = true
            subtitleSignImage.isHidden = true
        }
    }
}
