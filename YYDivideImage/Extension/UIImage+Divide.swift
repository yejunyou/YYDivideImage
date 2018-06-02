//
//  UIImage+Divide.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func divide(row: Int, col: Int) -> [UIImage]? {

        let originSize = self.size;
        let divideW: CGFloat = originSize.width/CGFloat(col);
        let divideH: CGFloat = originSize.height/CGFloat(row);

        var imageArray: [UIImage] = []
        
        for i in 0..<col*row {
            let indexX: CGFloat = CGFloat(i%col)
            let indexY: CGFloat = CGFloat(i/col)
            let divideRect = CGRect.init(x: indexX*divideW, y: indexY*divideH, width: divideW, height: divideH)
            if let divideImage = self.divideImage(rect: divideRect) {
                imageArray.append(divideImage)
            }
        }
        
        return imageArray
    }
    
    // MARK: 私有方法
    /// 裁剪
    private func divideImage(rect: CGRect) -> UIImage? {
        if let imageRef: CGImage = self.cgImage {
            if let newCGImage = imageRef.cropping(to: rect) {
                return UIImage(cgImage: newCGImage)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func zip() -> UIImage {
        let data = UIImageJPEGRepresentation(self, 0.5)
        return UIImage(data: data!)!
    }
    
    func getDataSize() -> Int {
        let data = UIImageJPEGRepresentation(self, 1.0)
//        let data = UIImagePNGRepresentation(self)
        print("\((data?.count)! / 1024)KB")
        return (data?.count)! / 1024
    }
    
    func resize(maxSize: Int) -> UIImage? {
        let size = self.getDataSize()
        let time = CGFloat(size) / CGFloat(maxSize)
        let zip = CGFloat(1) / time
        let data = UIImageJPEGRepresentation(self, zip)
        return UIImage(data: data!)
    }
}
