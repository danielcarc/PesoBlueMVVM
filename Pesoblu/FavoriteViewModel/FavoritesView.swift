//
//  FavoritesView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 16/07/2025.
//

import SwiftUI
import Kingfisher

struct FavoritesView: View {
    
    let place = PlaceItem(id: 27, name: "Parque 3 de Febrero", address: "Av. Infanta Isabel 110", city: "CABA", state: "Buenos Aires", area: "Palermo", postalCode: "C1425", country: "Argentina", phone: "-", lat: -34.571495, long: -58.416759, price: "$", categories: ["Parque"], cuisines: nil, instagram: "https://www.instagram.com/parque3defebrero/", imageUrl: "https://www.dropbox.com/scl/fi/2qq2zanhbjaby08389xay/parque-tres-de-febrero.jpg?rlkey=bikkk6snu4p2n1dj0s157a2ay&raw=1", placeType: "Paseos", placeDescription: "Un gran parque urbano de Buenos Aires, conocido por sus amplias áreas verdes, lagos y espacios de recreación, ideal para caminatas y actividades al aire libre.")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            KFImage(URL(string: place.imageUrl))
                .placeholder {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 190)
                .cornerRadius(10)
                .clipped()
            
            Text(place.title ?? "")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(place.subtitle ?? "")
                .foregroundColor(.gray)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(place.price ?? "")
                .foregroundColor(.gray)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("0.0km")
                .foregroundStyle(Color.gray)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}
