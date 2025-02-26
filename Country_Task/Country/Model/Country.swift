//
//  Country.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String?
    var currencies: [Currency]?
    var latlng: [Double]?
    var alpha2Code: String?
    var flags: Flags?
}

 struct Currency: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}

struct Flags: Codable {
    let svg: String?
    let png: String?
}
