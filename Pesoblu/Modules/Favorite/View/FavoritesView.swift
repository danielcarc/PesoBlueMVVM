//
//  FavoritesView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var viewModel: FavoriteViewModel
    private let onSelect: (PlaceItem) -> Void
    
    private let columns = [GridItem(.flexible())]
    
    init(viewModel: FavoriteViewModel, onSelect: @escaping (PlaceItem) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSelect = onSelect
    }
    
    var body: some View {
        ScrollView{
            if viewModel.places.isEmpty {
                emptyState
            } else{
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.places, id: \.id){ places in
                        FavoritesItemView(place: places){
                            onSelect(places)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .background(Color(UIColor(hex: "F0F8FF")))
        .navigationTitle(Text("Favoritos"))
        .task{
            viewModel.loadFavorites()
        }
    }
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(.pink)
            Text("No tenés favoritos aún")
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
