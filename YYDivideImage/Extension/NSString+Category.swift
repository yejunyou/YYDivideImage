
//
//  NSString+Category.swift
//  YYSleepLight
//
//  Created by 叶俊有 on 2018/5/19.
//  Copyright © 2018年 PigGG. All rights reserved.
//

import UIKit

extension String {
    static func widthFromText(_ text: String, _ fontSize: CGFloat) -> CGFloat {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        return label.beatifulWidth()
    }
}
