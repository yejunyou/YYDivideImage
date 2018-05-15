//
//  YYHomeViewController.swift
//  YYDevideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import SnapKit

class YYHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInit()
        addsubview()
        layout()
    }
    
    // MARK : UI
    private func setupInit(){
        view.backgroundColor = UIColor.gray
        self.navigationItem.title = "YY分图"
    }
    
    private func addsubview (){
        view.addSubview(divideIamgeButton)
        view.addSubview(groupIamgeButton)
    }
    
    private func layout (){
        divideIamgeButton.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(49)
//            make.center.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(64)
        }
        
        groupIamgeButton.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(49)
            make.top.equalTo(divideIamgeButton.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func divideButtonClick() {
        print("%s",__FOUNDATION_NSPOINTERFUNCTIONS__);
    }
    
    
    // MARK: lazy add
    lazy private var divideIamgeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("打开相册", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(pickerImage), for: .touchUpInside)
        return button
    }()
    
    lazy private var groupIamgeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("打开相机", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(divideButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy private var pickerImageViewController: UIImagePickerController = {
        let pickerVC = UIImagePickerController.init()
        pickerVC.delegate = self
//        pickerVC.allowsEditing = true
        pickerVC.sourceType = .savedPhotosAlbum
        return pickerVC
    }()
    
    // MARK: event response
    @objc private func pickerImage(){
        self.present(pickerImageViewController, animated: true, completion: nil)
        
    }
}

// MARK : 打开相册
extension YYHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /// 选中图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 获取原图
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let divideVC = YYDivideImageViewController.init(image: image)
            self.navigationController?.pushViewController(divideVC, animated: true)
        }
    }
    
    /// 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

