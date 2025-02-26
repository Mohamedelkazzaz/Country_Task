//
//  CountryDetailView.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import Foundation
import SwiftUI


struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Country Image - Starts at spacing 0
                    if let imageUrl = country.flags?.png, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(country.name)
                            .font(.largeTitle)
                            .bold()
                        
                        if let capital = country.capital {
                            Text("Capital: \(capital)")
                        } else {
                            Text("Capital: N/A")
                        }
                        
                        if let currencies = country.currencies {
                            Text("Currency: \(currencies.compactMap { $0.code }.joined(separator: ", "))")
                        } else {
                            Text("Currency: N/A")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure leading alignment
                
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.top, 16)
            .navigationTitle("Detail")
        }
}
