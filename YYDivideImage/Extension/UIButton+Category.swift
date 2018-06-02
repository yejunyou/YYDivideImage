//
//  UIButton+Category.swift
//  YYSleepLight
//
//  Created by 叶俊有 on 2018/5/18.
//  Copyright © 2018年 PigGG. All rights reserved.
//

import UIKit


enum YYButtonStyle {
    case simpleBlueStyle
}

extension UIButton {
    convenience init(title: String, center: CGPoint , style: YYButtonStyle) {
        
        self.init()
        
        let buttonW: CGFloat = 120
        let buttonH: CGFloat = 50
        
        switch style {
        case .simpleBlueStyle:
            setTitle(title, for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = kColorHex(0x0a60fe)
            titleLabel?.font = UIFont.systemFont(ofSize: 18)
            self.size = CGSize.init(width: buttonW, height: buttonH)
            self.center = center
            self.layer.cornerRadius = buttonH/2
            self.layer.masksToBounds = true
        }
    }
    
    convenience init(title: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGray, backColor: UIColor = UIColor.white) {
        
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        backgroundColor = backColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    convenience init(title: String, imageName: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGray) {
        
        self.init()
        
        setTitle(title, for: .normal)
        setImage(UIImage.init(named: imageName), for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    convenience init(imageName: String) {
        self.init()
        
        setImage(imageName: imageName)
    }
    
    /// 使用图像名设置按钮图像
    func setImage(imageName: String) {
        setImage(UIImage.init(named: imageName), for: .normal)
        // 提示：如果高亮图片不存在，不会设置
        setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
    }
}
