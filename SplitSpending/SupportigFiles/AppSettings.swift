//
//  AppSettings.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class GraphicsSetting {
    private init(){}
    
    static func setAlpha(view: [UIView], alpha: CGFloat) {
        view.forEach {$0.alpha = alpha}
    }
    
    class BackgroundColor {
        private init(){}
        
        static func setBackgroundView(imageName: String) -> UIView {
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        
        static func setBackgroundColor(view: [UIView], backgroundColor: CGColor, alpha: CGFloat) {
            view.forEach {
                $0.layer.backgroundColor = UIColor(cgColor: backgroundColor).withAlphaComponent(alpha).cgColor
            }
        }
        
        static let backgroundColorFirstColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        static let backgroundColorSecondColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        static let backgroundColorStartPoint = CGPoint(x: 0, y: 0)
        static let backgroundColorEndPoint = CGPoint(x: 1, y: 1)
        
        static func createGradientLayerTwoColors(view: UIView, firstColor: UIColor, secondColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        }

    }
    
    class Dimension {
        private init(){}
        
        static func cornerRadius(view: [UIView], cornerRadius: CGFloat) {
            view.forEach {$0.layer.cornerRadius = cornerRadius}
        }
        static func borderWidth(view: [UIView], borderWidth: CGFloat) {
            view.forEach {$0.layer.borderWidth = borderWidth}
        }
        
        
    }
}



