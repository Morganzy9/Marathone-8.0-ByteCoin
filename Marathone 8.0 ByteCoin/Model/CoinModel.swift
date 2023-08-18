//
//  CoinModel.swift
//  Marathone 8.0 ByteCoin
//
//  Created by Ислам Пулатов on 8/18/23.
//

import Foundation

struct CoinModel: Codable {

    let assetIdBase: String
    let assetIdQuote: String
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case assetIdBase = "asset_id_base"
        case assetIdQuote = "asset_id_quote"
        case rate
    }

}



