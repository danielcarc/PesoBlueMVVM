//
//  UIView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 28/07/2025.
//

import UIKit


extension UIView{
    
    func applyBottomRightShadow() {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.layer.shadowRadius = 4
            self.layer.masksToBounds = false
        }
    
}
