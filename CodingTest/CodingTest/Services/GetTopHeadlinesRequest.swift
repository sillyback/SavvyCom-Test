//
//  GetTopHeadlinesRequest.swift
//  CodingTest
//
//  Created by Chung Cr on 02/06/2022.
//

import Foundation

class GetTopHeadlinesRequest: APIRequest {
    typealias Response = NewsListResponse
    
    var identifier: APIRequestDefinition = APIDefine.topHeadlines
    
    static let shared = GetTopHeadlinesRequest()
}
