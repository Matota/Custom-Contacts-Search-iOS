//
//  Utilities.swift
//  CusomContact
//
//  Created by Hitesh on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

public struct ThemeColors {
    
    static let emeraldColor         = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
    static let sunflowerColor       = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
    static let pumpkinColor         = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
    static let asbestosColor        = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
    static let amethystColor        = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
    static let peterRiverColor      = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
    static let pomegranateColor     = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
    static let lightGrayColor       = UIColor(red:0.79, green:0.78, blue:0.78, alpha:1)
    
    public static var colorArray: [UIColor] = [
        ThemeColors.amethystColor,
        ThemeColors.asbestosColor,
        ThemeColors.emeraldColor,
        ThemeColors.peterRiverColor,
        ThemeColors.pomegranateColor,
        ThemeColors.pumpkinColor,
        ThemeColors.sunflowerColor
    ]
    
    static func updateInitialsColorForIndexPath(_ indexpath: IndexPath) -> UIColor {
        
        //Applies color to Initial Label
        let randomValue = (indexpath.row + indexpath.section) % self.colorArray.count
        
        return self.colorArray[randomValue]
    }
}
