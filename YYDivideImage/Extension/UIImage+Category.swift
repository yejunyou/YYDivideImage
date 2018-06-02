//
//  UIImage+Category.swift
//  YYSleepLight
//
//  Created by 叶俊有 on 2018/5/24.
//  Copyright © 2018年 PigGG. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(_ color: UIColor){
        self.init()
        let ctx = UIGraphicsGetCurrentContext()
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0)
        ctx?.setFillColor(color.cgColor)
        let _ = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    convenience init(_ color: UIColor, _ size: CGSize){
        self.init()
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addRect(CGRect.init(origin: CGPoint.zero, size: size))
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height + 44)
            , false, 0)
        ctx?.setFillColor(color.cgColor)
        let _ = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
