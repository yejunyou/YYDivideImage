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
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YY分图"
        addSubviews()
        layout()
    }
    
    private func addSubviews(){
        view.addSubview(imageView)
    }
    
    private func layout(){
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(44)
            make.bottom.equalTo(-15)
        }
    }
    
    // MARK : LAZY ADD
    lazy private var imageView: UIImageView = {
        let iv = UIImageView.init()
        iv.backgroundColor = UIColor.yellow
        return iv
    }()
}
