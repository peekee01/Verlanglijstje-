//
//  MaterialView.swift
//  DreamLister
//
//  Created by Pieter Kuijsten on 30/12/2016.
//  Copyright © 2016 Pieter Kuijsten. All rights reserved.
//

import UIKit


private var materialKey = false

extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 4.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 5.0
                self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.9).cgColor
            } else {
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
            }
        }
    }
}

