//
//  FavoritesView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var viewModel: FavoriteViewModel
    private let onSelect: (PlaceItem) -> Void
    
    private let columns = [GridItem(.flexible())]
    
    init(viewModel: FavoriteViewModel, onSelect: @escaping (PlaceItem) -> Void) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    var body: some View {
        ScrollView{
            if viewModel.places.isEmpty {
                emptyState
            } else{
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.places, id: \.id) { place in
                        FavoritesItemView(place: place) {
                            onSelect(place)
                        }
                    }
                }
                .padding(.horizontal)
            }

        }
        .background(Color(.systemBackground))
        .navigationTitle("favorites_title")
        .task{
            await viewModel.loadFavorites()
        }
    }
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(.pink)
            Text("no_favorites_yet")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
}


//#Preview {
//    FavoritesView()
//}
