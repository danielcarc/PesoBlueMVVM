//
//  PlaceError.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

enum PlaceError: Error {
    case fileNotFound
    case failedToParseData
    case noPlacesAvailable
}

enum APIError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case decodingError
}
