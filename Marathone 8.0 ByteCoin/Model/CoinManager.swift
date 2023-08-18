//
//  CoinManager.swift
//  Marathone 8.0 ByteCoin
//
//  Created by Ислам Пулатов on 8/18/23.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didPriceChange(price: String, currency: String)
    func didFailWithError(error: Error)
}


struct  CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "apikey=90C15E23-314F-4FC5-BCF0-1FCE52693106"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=90C15E23-314F-4FC5-BCF0-1FCE52693106
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?\(apiKey)"
        
        performRequest(with: urlString)   
    }
    
    
    func performRequest(with urlString: String) {
        
        guard let urlRequest = URL(string: urlString) else {
            
            delegate?.didFailWithError(error: "Error" as! Error)
            
            return
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                
                delegate?.didFailWithError(error: error)

                return
            }
            
            guard let safeData = data else { return }
            
            guard let parsedData = parseCoin(with: safeData) else { return }
            
            let priceOfCoin = String(format: "%.2f", parsedData.rate)
            
            delegate?.didPriceChange(price: String(describing: priceOfCoin), currency: parsedData.assetIdQuote)
            
            
        }.resume()
        
    }
    
    
    func parseCoin(with data: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CoinModel.self, from: data)
            
            let coinModel = CoinModel(assetIdBase: decodedData.assetIdBase, assetIdQuote: decodedData.assetIdQuote, rate: decodedData.rate)
            
            
            return coinModel
            
        } catch {
            
            print("Error")
            
            delegate?.didFailWithError(error: error)
            
            return nil
        }
        
    }
    
    
}
