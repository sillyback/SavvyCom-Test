//
//  APIDefinition.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import Alamofire

enum APIDefine: APIRequestDefinition {
    static let domain: String = "https://newsapi.org/v2/"
    static let apiKey: String = "70bdf00c44bd4796982d5737a0035c4e"
    /// Get news list
    case getNewsList
    
    var url: URLConvertible {
        switch self {
        case .getNewsList:
            return APIDefine.domain + "everything"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNewsList:
            return .get
        }
    }
    
    var defaultParam: Parameters {
        var params: Parameters = ["apiKey": APIDefine.apiKey]
        // TODO: config for each API
        return params
    }
}
