//
//  GetNewsListRequest.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation

class GetNewsListRequest: APIRequest {
    typealias Response = NewsListResponse
    
    static let shared = GetNewsListRequest()
    var identifier: APIRequestDefinition = APIDefine.getNewsList
}
