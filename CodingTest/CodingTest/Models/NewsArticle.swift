//
//  NewsArticle.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation

struct NewsListResponse: BaseAPIResponse {
    let status: ResponseStatus
    let totalResults: Int?
    let articles: [NewsArticle]?
    let code: String?
    let message: String?
}

struct NewsArticle: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
