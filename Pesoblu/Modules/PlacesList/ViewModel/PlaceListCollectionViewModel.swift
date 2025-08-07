import Foundation

struct PlaceItemViewModel {
    let place: PlaceItem
    let title: String
    let price: String
    /// Distance string already formatted for presentation.
    let formattedDistance: String
    let type: String
    let imageUrl: String
}

final class PlaceListCollectionViewModel {

    private let placesListViewModel: PlacesListViewModelProtocol

    init(placesListViewModel: PlacesListViewModelProtocol) {
        self.placesListViewModel = placesListViewModel
    }

    func makeItems(from places: [PlaceItem], filter: PlaceType) -> [PlaceItemViewModel] {
        let filtered: [PlaceItem]
        if filter != .all {
            filtered = placesListViewModel.filterData(places: places, filter: filter)
        } else {
            filtered = places
        }

        return filtered.map { place in
            PlaceItemViewModel(
                place: place,
                title: place.name,
                price: place.price ?? "N/A",
                formattedDistance: placesListViewModel.getDistanceForPlace(place),
                type: place.subtitle ?? "N/A",
                imageUrl: place.imageUrl
            )
        }
    }
}

