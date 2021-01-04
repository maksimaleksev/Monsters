//
//  UIButton+Extension.swift
//  Monsters
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import UIKit

extension UIButton {
    
    func setButtonColor(textColor: UIColor, backgroundColor: UIColor) {
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = textColor
    }
    
}
