//
//  PrimaryViewModel.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation
import UIKit
import Kingfisher

protocol ViewModelDelegate {
    func updateUI()
}

class PrimaryViewModel {
    
    // MARK: Properties
    var delegate: ViewModelDelegate?
    var counts: Int = 0
    private var coinsData: CoinList? {
        didSet {
            self.saveDataInStorage()
            self.downloadImages()
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.setTopCoins()
                strongSelf.delegate?.updateUI()
            }
        }
    }
    private var topCoins: CoinList?
    private var imageDictionary = [String: UIImage]()
    
    // MARK: Methods
    func makeNetworkCall() {
        
        NetworkManager.shared.apiCall() { [weak self] result in
            guard let strongSelf = self else { return }
           
            switch result {
            case .success(let data):
                strongSelf.coinsData = data
                    
            case .failure(let error):
                print(error, "--")
            }
        }
    }
    
    func getCoinsCount() -> Int {
        return coinsData?.count ?? 0
    }
    
    func getCoinData(_ index: Int) -> Coin? {
        return coinsData?[index]
    }
    
    func setTopCoins() {
        guard let coinsData = coinsData else { return }
        let topMovers = coinsData.sorted(by: {$0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0}).prefix(10)
        self.topCoins = CoinList(Array(topMovers))
    }
    
    func getTopCoinsData(_ index: Int) -> Coin? {
        return topCoins?[index]
    }
    
    func getImageAtId(_ id: String) -> UIImage? {
        return imageDictionary[id]
    }
    
    func downloadImages() {
        guard let coinsData = coinsData else {return}
        
        for coin in coinsData {
            counts += 1
            guard let url = coin.image else { return }
            NetworkManager.shared.downloadImage(from: url) { [weak self] image, error in
                if let error = error {
                        // Handle the error
                        print("Error downloading image: \(error.localizedDescription)")
                    } else if let image = image {
                        // Do something with the downloaded image
                        self?.imageDictionary[coin.id] = image
                    }
                self?.counts -= 1
                if self!.counts < 1 {
                    self?.delegate?.updateUI()
                }
            }
            
        }
    }
    func saveDataInStorage() {
        guard let coinsData = coinsData else {return}

        let coin = coinsData[0]
//            let dataToSave = CoinEntity(context: PersistentStorage.shared.context)
//            dataToSave.name = coin.name
//            dataToSave.priceChangePercentage24H = coin.priceChangePercentage24H ?? 0
//            dataToSave.symbol = coin.symbol
//           // dataToSave.image = imageDictionary[coin.id]!.pngData()
//            dataToSave.id = coin.id
//            PersistentStorage.shared.saveContext()
    }
}
