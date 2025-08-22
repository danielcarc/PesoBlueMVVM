//
//  FavoritesItemView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 16/07/2025.
//

import SwiftUI
import Kingfisher

struct FavoritesItemView: View {
    
    let place : PlaceItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            cardContent
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
    
    private var cardContent: some View{
        VStack(alignment: .leading, spacing: 8){
            KFImage(URL(string: place.imageUrl))
                .placeholder {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .padding()
                }
                .resizable()
                .aspectRatio(16/9, contentMode: .fill)
                .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 190)
                .cornerRadius(12)
                .clipped()
                .accessibilityLabel(place.title ?? "Imagen de lugar")
            
            VStack(alignment: .leading, spacing: 4){
                Text(place.title ?? "")
                    .font(.headline)
                Text(place.subtitle ?? "")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text(place.price ?? "")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text(place.distance ?? "0.0km")
                    .foregroundStyle(Color.gray)
                    .font(.subheadline)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        .padding(.vertical, 4)
    }
}
