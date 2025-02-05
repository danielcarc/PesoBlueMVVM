//
//  PlaceViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 30/01/2025.
//

import Foundation
import UIKit


class PlaceViewModel{
    
    func downloadImage(from url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (imageData, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: imageData) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        return image
    }
}
