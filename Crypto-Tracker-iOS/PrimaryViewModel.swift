//
//  PrimaryViewModel.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation

protocol ViewModelDelegate {
    func updateUI()
}

class PrimaryViewModel {
    
    // MARK: Properties
    var delegate: ViewModelDelegate?
    private var coinsData: CoinList? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.setTopCoins()
                strongSelf.delegate?.updateUI()
            }
        }
    }
    private var topCoins: CoinList?
    
    // MARK: Methods
    func makeNetworkCall() {
        NetworkManager.shared.apiCall() { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let data):
                strongSelf.coinsData = data
                    
            case .failure(let error):
                print(error)
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
}
