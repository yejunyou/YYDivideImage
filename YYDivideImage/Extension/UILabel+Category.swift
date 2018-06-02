//
//  UILabel+Category.swift
//  YYSleepLight
//
//  Created by 叶俊有 on 2018/5/18.
//  Copyright © 2018年 PigGG. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(color: UIColor, fontSize: CGFloat){
        self.init()
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func beatifulWidth() -> CGFloat {
        let size = self.sizeThatFits(CGSize.init(width: 20, height: 20))
        return size.width
    }
    
    func widthFromText(_ text: String, _ fontSize: CGFloat) -> CGFloat {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        return label.beatifulWidth()
    }
}
