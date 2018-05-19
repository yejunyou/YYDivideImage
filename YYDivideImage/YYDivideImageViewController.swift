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
    private var imageViews: [UIImageView]? = []
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
        refreshLayout(row: pickerView.selectedRow, col: pickerView.selectedCol)
        setupNavItem()
    }
    
    private func addSubviews(){
        view.addSubview(pickerView)
    }
    private func setupNavItem() {
        let b = UIBarButtonItem(title: "resize", style: .plain, target: self, action:#selector(showPickerView))
        self.navigationItem.rightBarButtonItem = b
    }
    
    @objc private func showPickerView() {
        pickerView.show()
        view.bringSubview(toFront: pickerView)
    }
    
    private func layout(){
        
    }
    
    // MARK: ==private method==
    private func refreshLayout(row: Int, col: Int) {
        
        divideImages = self.image.divide(row: row, col: col);
        
        let image = divideImages?.first
        let margin: CGFloat = 1;
        let kScreenW: CGFloat = UIScreen.main.bounds.size.width
        let imageOriginalW: CGFloat = (image?.size.width)! * CGFloat(col)
//        let imageOriginalH: CGFloat = (image?.size.height)! * CGFloat(row)
        
        let scaleW = imageOriginalW/kScreenW
        
        let imageW: CGFloat = (image?.size.width)!/scaleW
        let imageH: CGFloat = (image?.size.height)!/scaleW
        var imageX: CGFloat = 0;
        var imageY: CGFloat = 0;
        
        var index: Int = 0
        for i in 0..<row*col {
            let iv: UIImageView = UIImageView.init()
            let image = divideImages?[index]
            let indexX: CGFloat = CGFloat(i%col)
            let indexY: CGFloat = CGFloat(i/row)
            imageX = margin + imageW * indexX + indexX * margin
            imageY = 64 + imageH * indexY + indexY * margin
            iv.frame = CGRect.init(x: imageX, y: imageY, width: imageW, height: imageH)
            
            view.addSubview(iv)
            imageViews?.append(iv)
            iv.image = image
            index += 1
        }
    }
    
    // MARK: ==LAZY ADD==
    private lazy var pickerView: YYNumberPickerView = {
        let picker = YYNumberPickerView.init(frame: view.bounds)
        picker.block = {(_ row: Int, _ col: Int) in
            
            self.divideImages?.removeAll();
            
            if self.imageViews?.isEmpty == false {
                print("imageViews count = \(String(describing: self.imageViews?.count))")
                for item in self.imageViews!{
                    item.removeFromSuperview()
                }
            }
            
            self.imageViews?.removeAll()
            
            self.refreshLayout(row: row, col: col)
            
            print("row = \(row) col = \(col)")
            print("imageViews count = \(String(describing: self.imageViews?.count))")
        }
        return picker
    }()
}
