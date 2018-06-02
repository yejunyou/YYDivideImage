//
//  Common.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/6/2.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kNavBarHeight: CGFloat = 44
let kTopHeight = kStatusBarHeight + kNavBarHeight
let kTabBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height > 20 ? 83 : 49
let kIsIphoneX = kStatusBarHeight > 20 ? true : false


func yyLog<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\(fileName):\(line) \(function) | \(message)")
    #endif
}
