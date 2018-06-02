//
//  UIButton+Category.swift
//  YYSleepLight
//
//  Created by 叶俊有 on 2018/5/18.
//  Copyright © 2018年 PigGG. All rights reserved.
//

import UIKit

extension UIButton {
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
