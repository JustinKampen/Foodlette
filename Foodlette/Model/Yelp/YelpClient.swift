//
//  YelpClient.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

class YelpClient {
    
    // -------------------------------------------------------------------------
    // MARK: - Yelp API Endpoints
    
    enum Endpoints {
        static let base = "https://api.yelp.com/v3/businesses/"
        
        case getBusinessDataFor(String, String, String)
        
        var stringValue: String {
            switch self {
            case .getBusinessDataFor(let categories, let latitude, let longitude):
                return Endpoints.base + "search?categories=\(categories)&latitude=\(latitude)&longitude=\(longitude)&limit=50"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Yelp API Call
    
    class func getBusinessDataFor(categories: String, latitude: String, longitude: String, completion: @escaping ([Business]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getBusinessDataFor(categories, latitude, longitude).url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let businessData = try decoder.decode(YelpResponse.self, from: data)
                completion(businessData.businesses, nil)
            } catch {
                completion(nil, error)
                debugPrint(error.localizedDescription)
            }
        }
        task.resume()
    }
}
