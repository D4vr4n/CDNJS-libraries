//
//  NewsResponse.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 16.12.2020.
//

import Foundation

struct NewsResponse: Decodable {
    var articles: [Article]?
}

struct Article: Decodable {
    var author: String?
    var title: String?
    var url: String?
    var urlToImage: String?
}
