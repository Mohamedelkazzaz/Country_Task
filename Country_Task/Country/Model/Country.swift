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
}

 struct Currency: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}
