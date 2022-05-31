//
//  BaseAPIResponse.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation

enum ResponseStatus: String, Codable {
    case ok
    case error
}

protocol BaseAPIResponse: Codable {
    var status: ResponseStatus { get }
    var code: String? { get }
    var message: String? { get }
}

struct APIError: LocalizedError {
    var code: String?
    var message: String?
    
    var errorDescription: String? {
        return self.message
    }
}
