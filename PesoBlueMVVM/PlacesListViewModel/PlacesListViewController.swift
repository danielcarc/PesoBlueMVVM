//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

import UIKit

class PlacesListViewController: UIViewController {
    
    var selectedPlaces: [PlaceItem]?
    var selectedCity: String?
    var placeType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedPlaces?.count ?? "No se encontraron lugares")
        print(selectedCity ?? "N/A")
        print(placeType ?? "N/A place")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
