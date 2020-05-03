//
//  Constants.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

struct Network {
    struct URLS {
        static var baseURL: URL {
            guard let url = URL(string: "https://us-central1-minhasnotas.cloudfunctions.net/api") else { fatalError("baseURL is not a valid URL") }
            return url
        }
    }
    struct Headers {
        static var contentTypeWithAuthJSON = ["Content-Type": "application/json"]
    }
}

// Segues identifiers
struct Segue {
    static let loginToMain = "mainSegue"
}

// Login error code
struct LoginError {

}
