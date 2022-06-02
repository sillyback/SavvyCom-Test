//
//  GetNewsListRequest.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation

class GetNewsListRequest: APIRequest {
    typealias Response = NewsListResponse
    
    var identifier: APIRequestDefinition = APIDefine.getNewsList
    
    static let shared = GetNewsListRequest()
}
