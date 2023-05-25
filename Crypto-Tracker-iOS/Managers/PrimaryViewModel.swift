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
    var detailsDelegate: ViewModelDelegate?
    var counts: Int = 0
    private var coinsData: CoinList? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.downloadImages()
                strongSelf.setTopCoins()
                strongSelf.delegate?.updateUI()
            }
        }
    }
    private var topCoins: CoinList?
    private var priceRankers: CoinList?
    private var imageDictionary = [String: UIImage]()
    
    var infoDictionary = [String: CoinInfo]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.detailsDelegate?.updateUI()
            }
        }
    }
    
    // MARK: Methods
    func makeNetworkCall(_ urlString: String = Constants.URL) {
        
        if !NetworkManager.shared.isNetworkAvailable() {
            print("No INTERNET -- ")
        }
        
        NetworkManager.shared.apiCall(urlString) { [weak self] result in
            guard let strongSelf = self else { return }
           
            switch result {
            case .success(let data):
                strongSelf.decodeData(data)
                
            case .failure(let error):
                print(error, "--")
            }
        }
    }
    
    private func decodeData(_ data: Data) {
        
            if let responseData = try? JSONDecoder().decode(CoinList.self, from: data) {
                self.coinsData = responseData
            } else if let responseData = try? JSONDecoder().decode(CoinInfo.self, from: data) {
                self.infoDictionary[responseData.id] = responseData
            } else {
                print(NetworkError.unableToParse)
            }
    }
    
    func getCoinsCount() -> Int {
        return coinsData?.count ?? 0
    }
    
    func getCoinData(_ index: Int) -> Coin? {
        return coinsData?[index]
    }
    
    private func setTopCoins() {
        guard let coinsData = coinsData else { return }
        let topMovers = coinsData.sorted(by: {$0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0}).prefix(10)
        self.topCoins = CoinList(Array(topMovers))
        
        DispatchQueue.global(qos: .userInteractive).async {
            let rankers = coinsData.sorted(by: {$0.currentPrice > $1.currentPrice })
            self.priceRankers = CoinList(Array(rankers))
        }
    }
    
    func getPriceRank(_ id: String) -> String {
        guard let rankersList = priceRankers else {return "N/A"}
        return "\(rankersList.firstIndex(where: { $0.id == id })! + 1)"
    }
    
    func getTopCoinsData(_ index: Int) -> Coin? {
        return topCoins?[index]
    }
    
    func getImageAtId(_ id: String) -> UIImage? {
        return imageDictionary[id]
    }
    
    func downloadImages() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            guard let self = self else { return }
            guard let coinsData = self.coinsData else {return}
            
            for coin in coinsData {
                self.counts += 1
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
    }
    
    func saveDataInStorage() {
    }
}
