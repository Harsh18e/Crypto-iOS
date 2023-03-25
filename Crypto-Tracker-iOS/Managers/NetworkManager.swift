//
//  NetworkManager.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 04/03/23.
//

import Foundation
import UIKit
import Kingfisher
import SystemConfiguration

class NetworkManager {
    
    private init() {}
    public static let shared = NetworkManager()
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }

    
    func apiCall(_ isSuccess: Bool = true, completion: @escaping (Result<CoinList, NetworkError>) -> Void) {
        
        let urlString = Constants.URL
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"        
        
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
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let downloader = KingfisherManager.shared.downloader
        downloader.downloadImage(with: url, options: [.transition(.fade(0.2))]) { result in
            switch result {
            case .success(let value):
                completion(value.image, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
