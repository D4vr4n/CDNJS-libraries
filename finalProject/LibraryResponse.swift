//
//  Library.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 14.12.2020.
//

import Foundation

struct LibraryResponse: Decodable {
    var results: [Library]?
}

struct Library: Decodable {
    var name: String?
    var latest: String?
    var version: String?
    var description: String?
    var homepage: String?
}
