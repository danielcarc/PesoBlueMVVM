//
//  NotificationService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 16/03/2025.
//
import Foundation
import UIKit

protocol NotificationServiceProtocol {
    func checkPermission(dolar: String)
}
class NotificationService: NotificationServiceProtocol {
    
    func dispatchNotificaction(dolar: String){
        let identifier = "dolarValueNotification"
        let title = "Actualizacion del Dolar"
        let body = "El valor del Dolar es: $\(dolar)"
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("se deberia imprimir")
            }
        }
    }
    
    func checkPermission(dolar: String){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow{
                        self.dispatchNotificaction(dolar: dolar)
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotificaction(dolar: dolar)
                print("permitido \(dolar)")
            default:
                return
            }
        }
    }
}
