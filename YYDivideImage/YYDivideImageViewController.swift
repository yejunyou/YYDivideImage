//
//  YYDivideImageViewController.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit

class YYDivideImageViewController: UIViewController {
    
    private var image: UIImage
    private var divideImages: [UIImage]?
    private var imageCount: Int?
    
    // MARK: init ==method==
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
//        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        addSubviews()
        layout()
        
        // 默认3x3
        refreshLayout(row: 3, col: 3)
    }
    
    private func addSubviews(){
//        view.addSubview(imageView)
    }
    
    private func layout(){
//        imageView.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.top.equalTo(44)
//            make.bottom.equalTo(-15)
//        }
    }
    
    // MARK: ==private method==
    private func refreshLayout(row: Int, col: Int) {
        divideImages?.removeAll();
        divideImages = self.image.divide(row: row, col: col);
        var index: Int = 0
        
        let margin: CGFloat = 1;
        let imageW: CGFloat = (view.bounds.size.width - margin *  CGFloat(col + 1)) / CGFloat(col);
        let imageH: CGFloat = imageW;//(view.bounds.size.height - margin *  CGFloat(row + 1)) / CGFloat(row);
//        CGFloat imageW = CGFloat(self.image.getDataSize());
        var imageX: CGFloat = 0;
        var imageY: CGFloat = 0;
        
        for i in 0..<row*col {
            let indexX: CGFloat = CGFloat(i%col)
            let indexY: CGFloat = CGFloat(i/row)
            imageX = margin + imageW * indexX + indexX * margin
            imageY = 64 + imageH * indexY + indexY * margin
            let iv: UIImageView = UIImageView.init(frame: CGRect.init(x: imageX, y: imageY, width: imageW, height: imageH))
            view.addSubview(iv)
            iv.image = divideImages?[index]
            index += 1
            
        }
    }
    
    // MARK: ==LAZY ADD==
//    lazy private var imageView: UIImageView = {
//        let iv = UIImageView.init()
//        iv.backgroundColor = UIColor.yellow
//        return iv
//    }()
}
