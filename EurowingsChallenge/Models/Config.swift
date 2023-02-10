//
//  Config.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

class Config: Codable {
    let api: ApiConfig
}

class ApiConfig: Codable {
    let scheme: String
    let host: String
}
