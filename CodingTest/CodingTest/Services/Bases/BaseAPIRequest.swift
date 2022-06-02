//
//  BaseAPIRequest.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol APIRequestDefinition {
    var url: URLConvertible { get }
    var method: HTTPMethod { get }
    var defaultParam: Parameters { get }
}

protocol APIRequest {
    associatedtype Response: BaseAPIResponse
    
    var identifier: APIRequestDefinition { get }
    func buildParam(from dict: [String: Any]) -> Parameters
    func request(param: [String: Any]) -> Observable<Response>
}

extension APIRequest {
    
    func buildParam(from dict: [String: Any]) -> Parameters {
        var defaultParam = self.identifier.defaultParam
        guard !dict.isEmpty else {
            return defaultParam
        }
        
        for data in dict.enumerated() {
            defaultParam[data.element.key] = data.element.value
        }
        return defaultParam
    }
    
    func request(param: [String: Any]) -> Observable<Response> {
        let parameters = self.buildParam(from: param)
        
        return RxAlamofire.requestData(self.identifier.method,
                                       self.identifier.url,
                                       parameters: parameters)
        .observe(on: MainScheduler.instance)
        .flatMap({ (_, data) -> Observable<Response> in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Response.self, from: data)
                guard response.status == .ok else {
                    return .error(APIError(code: response.code, message: response.message))
                }
                return .just(response)
            } catch (let error) {
                return .error(error)
            }
        })
    }
}
