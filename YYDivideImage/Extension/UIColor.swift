//
//  UIColor.swift
//  YYSleepLight
//
//  Created by yejunyou on 2018/4/24.
//  Copyright © 2018年 nykj. All rights reserved.
//

import UIKit

// MARK: -颜色方法
func kRGBAColor (_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func kRGBColor(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return kRGBAColor(r, g: g, b: b, a: 1)
}

func kColorGray(_ gray :CGFloat) -> UIColor {
    return kRGBColor(gray, g: gray, b: gray)
}

// MARK: 随机色
func kRandomColor ()-> UIColor{
    return kRGBColor(CGFloat(arc4random_uniform(255))/255.0, g: CGFloat(arc4random_uniform(255))/255.0, b: CGFloat(arc4random_uniform(255))/255.0)
}

func kColorHex(_ rgbValue: Int) -> (UIColor) {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}

func kMainBlueColor() -> (UIColor) {
    return kColorHex(0x23CDFD)
}

//
extension UIColor {
    static func yy_HexColor (hex: String)-> UIColor{
        
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.newlines).uppercased()
        

        if (cString.hasPrefix("#")) {
             cString = (cString as NSString).substring(from:1)
        }
        
        if (cString.count != 6) {
            return UIColor.black
        }
        
        let rString = (cString as NSString).substring(from:2)
        let gString = ((cString as NSString).substring(from:2) as NSString).substring(to:2)
        let bString = ((cString as NSString).substring(from:4) as NSString).substring(to:2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
