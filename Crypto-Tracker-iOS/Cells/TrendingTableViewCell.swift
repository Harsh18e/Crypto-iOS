//
//  TrendingTableViewCell.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 06/03/23.
//

import UIKit

protocol TrendingTableViewCellDelegate {
    func didSelectCellAtID(_ id: String, _ index: Int)
}

class TrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PrimaryViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate:TrendingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: TrendingCollectionViewCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension TrendingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! TrendingCollectionViewCell
        if let topCoinData = viewModel?.getTopCoinsData(indexPath.row) {
            cell.setupCell(topCoinData,viewModel?.getImageAtId(topCoinData.id))
        }
        // Set up shadow layer
        cell.layer.shadowColor = UIColor.green.cgColor
        cell.layer.shadowOffset = CGSize(width: 6, height: 8)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = (viewModel?.getTopCoinsData(indexPath.row)) else {return}
        let coinName = data.id
        let index = (data.marketCapRank ?? 1) - 1
        delegate?.didSelectCellAtID(coinName,Int(index))
    }
}
