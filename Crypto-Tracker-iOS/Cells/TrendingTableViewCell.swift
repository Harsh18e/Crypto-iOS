//
//  TrendingTableViewCell.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 06/03/23.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PrimaryViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: TrendingCollectionViewCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: "collectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension TrendingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! TrendingCollectionViewCell
        if let topCoinsData = viewModel?.getTopCoinsData(indexPath.row) {
            cell.setupCell(topCoinsData)
        }
        return cell
    }
}
