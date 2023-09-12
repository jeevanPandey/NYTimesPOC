//
//  NetworkConfig.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//

import Foundation

struct NetworkConfig {
   
    static let baseURLString = "https://api.nytimes.com/svc/topstories/v2/world.json"
    enum HTTPHeaderFields {
        case appJson
        case appFormEncoded
        case none
        
        func setHeader(urlRequest: inout URLRequest)  {
            switch self {
                case .appJson:
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .appFormEncoded:
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                case .none: break
            }

        }
        var headers : [String:String] {
            switch self {
                case .appJson:
                    return ["Content-type":"application/json"]
                case .appFormEncoded:
                    return ["Content-type":"application/x-www-form-urlencoded"]
                case .none:
                return ["":""]
            }
        }
    }
    
    enum HTTPMehod : String {
        case GET = "GET"
        case POST = "POST"
    }
    
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case decodingError(err: String)
    case error(err: String)
}


extension NetworkConfig {
    static let apikey = "RiTezICSAaZ5XpGZmatS198JEYwMiaBT"
//    static func baseURL() -> String {
//        return baseURLString
//    }
    
    static func getURLForNewList() -> String {
      return "\(baseURLString)?api-key=\(apikey)"
    }


}
