//
//  UIColor+Rand.swift
//  FunWithFlags
//
//  Created by Manu Rink on 12.07.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    static func randomColor(seed: String) -> UIColor {
        
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}
