//
//  UIView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 28/07/2025.
//

import UIKit


extension UIView{
    //siempre en el metodo override layoutsubviews
    func applyCardShadow(cornerRadius: CGFloat = 12, shadowOpacity: Float = 0.1) {
        layer.cornerRadius = cornerRadius //
        layer.masksToBounds = false //
        layer.shadowColor = UIColor.black.cgColor //
        layer.shadowOpacity = shadowOpacity //
        layer.shadowOffset = CGSize(width: 0, height: 2) //
        layer.shadowRadius = 4 //
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    func applyVerticalGradientBackground(colors: [UIColor], cornerRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.name = "backgroundGradient"
        
        // Eliminar cualquier gradiente anterior
        layer.sublayers?.removeAll(where: { $0.name == "backgroundGradient" })
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///en override layoutsuviews
//    applyVerticalGradientBackground(colors: [
//            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1),
//            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1)
//        ])
}
