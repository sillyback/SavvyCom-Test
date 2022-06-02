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
    /// Top headlines
    case topHeadlines
    
    var url: URLConvertible {
        switch self {
        case .getNewsList:
            return APIDefine.domain + "everything"
        case .topHeadlines:
            return APIDefine.domain + "top-headlines"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNewsList, .topHeadlines:
            return .get
        }
    }
    
    var defaultParam: Parameters {
        var params: Parameters = [ParameterKey.apiKey: APIDefine.apiKey]
        
        switch self {
        case .topHeadlines:
            params[ParameterKey.category] = "technology"
            
        default:
            break
        }
        
        return params
    }
}
