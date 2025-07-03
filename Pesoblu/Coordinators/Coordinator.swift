//
//  Coordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
