//
//  CountryService.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import Foundation

 protocol CountryServiceProtocol {
    func fetchAllCountries(completion: @escaping (Result<[Country], Error>) -> Void)
}

public class CountryService: CountryServiceProtocol {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAllCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v2/all") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

public enum ServiceError: Error {
    case invalidURL
    case noData
}
