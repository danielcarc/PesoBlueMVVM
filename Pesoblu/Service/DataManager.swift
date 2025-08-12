//
//  DataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation

protocol DataManager {
    func loadPlist(file name: String) -> Result<[[String: AnyObject]], DataManagerError>
}

enum DataManagerError: Error, Equatable {
    case fileNotFound
    case invalidFormat
}

extension DataManager {
    func loadPlist(file name: String) -> Result<[[String: AnyObject]], DataManagerError> {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
              let itemsData = FileManager.default.contents(atPath: path) else {
            return .failure(.fileNotFound)
        }
        
        do {
            if let items = try PropertyListSerialization.propertyList(from: itemsData, format: nil) as? [[String: AnyObject]] {
                return .success(items)
            } else {
                return .failure(.invalidFormat)
            }
        } catch {
            return .failure(.invalidFormat)
        }
    }
}
