//
//  YYHomeViewController.swift
//  YYDevideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import Photos
import PKHUD

class YYHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorHex(0xf5f5f5)
        
        setupInit()
        addsubview()
//        layout()
    }
    
    // MARK: ==event response==
    @objc private func pickerImage(){
        if getAlbumPermission() == false{
            HUD.flash(.label("没有访问相册权限，请到系统设置授权，么么哒"), delay: 3)
            return
        }
        
        let pickerVC = UIImagePickerController.init()
//        pickerVC.allowsEditing = true
        pickerVC.sourceType = .savedPhotosAlbum
        pickerVC.delegate = self
        pickerVC.delegate = self
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    @objc func cameraClick() {
        if getCameraPermissions() == false {
            HUD.flash(.label("没有拍照权限，请到系统设置授权，么么哒"), delay: 3)
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController.init()
//            cameraPicker.allowsEditing = true
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            HUD.flash(.label("没有拍照权限，请到系统设置授权，么么哒"), delay: 3)
        }
    }
    
    // 相册授权
    func getAlbumPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
  
    // 相机权限
    private func getCameraPermissions()-> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (auth) in
            
            })
            return true
        } else if authStatus == .authorized {
            return true
        } else {
            return false
        }
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
    
    
    // MARK: lazy add
    
    lazy private var divideIamgeButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "打开相册", center: CGPoint.init(x: kScreenW/2, y: kTopHeight + 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(pickerImage), for: .touchUpInside)
        return btn
    }()
    
    lazy private var groupIamgeButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "打开相机", center: CGPoint.init(x: kScreenW/2, y: divideIamgeButton.bottom + 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(cameraClick), for: .touchUpInside)
        return btn
    }()
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

