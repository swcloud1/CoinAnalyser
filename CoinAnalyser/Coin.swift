//
//  Coin.swift
//  CoinAnalyser
//
//  Created by Siwa Sardjoemissier on 15/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import Foundation

struct Coin: Codable {
    var name: String
    var TwelveWeeksDev: Double
    var commitArray = [Float]()
    var volumeArray = [Float?]()
    var trendArray = [Float]()
    
    static func loadCoins() -> [Coin]? {
        guard let codedCoins = try? Data(contentsOf: ArchiveURL)
            else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Coin>.self,
                                               from: codedCoins)
    }
    
    static func loadSampleCoins() -> [Coin] {
        let coin1 = Coin(name: "FakeCoin (Example)", TwelveWeeksDev: 0.00, commitArray: [0,0,0], volumeArray: [0,0,0], trendArray: [0])
        return [coin1]
    }
    
    static func saveCoins(_ coins: [Coin]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedCoins = try? propertyListEncoder.encode(coins)
        try? codedCoins?.write(to: ArchiveURL,
                               options: .noFileProtection)
    }
    
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask).first!
    static let ArchiveURL =
        DocumentsDirectory.appendingPathComponent("coins")
            .appendingPathExtension("plist")
}
