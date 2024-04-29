//
//  ChangeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

protocol ChangeViewModelDelegate: AnyObject{
    func didFinish()
    func didFail(error: Error)
}

class ChangeViewModel{
    
    weak var delegate : ChangeViewModelDelegate?
    
    
    
    private(set)var changes = [ChangesResponse] ()
    
    
    
    var changeArray = ["Oficial", "Blue", "Euro Blue"]
    
    @MainActor
    func getChange(){
        
        Task{ [weak self] in
            do{
                guard let url = URL(string: "https://api.bluelytics.com.ar/v2/latest") else { return }
                let (data, _) =  try await URLSession.shared.data(from: url)
                let jsonDecoder = JSONDecoder()
                let changesResponse = try jsonDecoder.decode(ChangesResponse.self, from: data)
                
                if var oficial = changesResponse.oficial {
                    oficial.dolarLabel = "Dolar Oficial"
                    self?.changes.append(ChangesResponse(oficial: oficial, blue: nil, blue_euro: nil, last_update: changesResponse.last_update))
                }
                if var blue = changesResponse.blue {
                    blue.dolarLabel = "Dolar Blue"
                    self?.changes.append(ChangesResponse(oficial: nil, blue: blue, blue_euro: nil, last_update: changesResponse.last_update))
                }
                if var blueEuro = changesResponse.blue_euro {
                    blueEuro.dolarLabel = "Euro Blue"
                    self?.changes.append(ChangesResponse(oficial: nil, blue: nil, blue_euro: blueEuro, last_update: changesResponse.last_update))
                }
                //print(self?.changes as Any)
                
                self?.delegate?.didFinish()
            }
            catch{
                self?.delegate?.didFail(error: error)
                
            }
        }
    }
    
}
