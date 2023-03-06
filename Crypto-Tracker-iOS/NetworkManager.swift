//
//  NetworkManager.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 04/03/23.
//

import Foundation

class NetworkManager {
    
    private init() {}
    public static let shared = NetworkManager()
    
    func apiCall(_ isSuccess: Bool = true, completion: @escaping (Result<CoinList, NetworkError>) -> Void) {
        
        let urlString = Constants.URL
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil, let data = data else {
                completion(.failure(NetworkError.apiError))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(CoinList.self, from: data)
                completion(.success(responseData))
            } catch(_) {
                completion(.failure(.unableToParse))
            }
            
        }.resume()
    }
}
