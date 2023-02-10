//
//  ConfigProvider.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

class ConfigProvider {
    static let sharedInstance = ConfigProvider()
    
    lazy var config: Config = {
        do {
            guard let configURL = Bundle.main.url(forResource: "config", withExtension: "json") else {
                fatalError("no config.json file in root dir found")
            }
            let jsonData = try Data(contentsOf: configURL)
            return try JSONDecoder().decode(Config.self, from: jsonData)
        }
        
        catch let error as NSError {
            fatalError("error parsing config.json file: \(error.localizedDescription)")
        }
    }()
    
    private init () {}
}
