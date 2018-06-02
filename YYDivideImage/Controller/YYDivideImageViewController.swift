//
//  YYDivideImageViewController.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import Photos
import PKHUD

enum PhotoAlbumUtilResult {
    case success
    case error
    case denied
}

class YYDivideImageViewController: UIViewController,UICollectionViewDelegate {
    
    private var imageSize: CGSize!
    private var image: UIImage
    private var divideImages: [UIImage]?
    private var currentCol: Int!
    private var currentRow: Int!
    private var imageCount: Int?
    private var localId: String?
    
    // view
//    private var previewCollectionView: UICollectionView!
    private let minspace: CGFloat = 3
    
    // MARK: init ==method==
    init(image: UIImage) {
        self.image = image
        self.imageSize = image.size
        super.init(nibName: nil, bundle: nil)

        currentCol = 3
        currentRow = 3
        refreshLayout(row: currentRow, col: currentCol)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColorHex(0xf5f5f5)
        
        addSubviews()
        setupNavItem()
    }
    
    
    private func addSubviews(){
        view.backgroundColor = UIColor(red: 109 / 255, green: 117 / 255, blue: 127 / 255, alpha: 1)
        view.addSubview(previewCollectionView)
        view.addSubview(pickerView)
        view.addSubview(rechoiceButton)
        view.addSubview(saveButton)
        
        previewCollectionView.height = view.bounds.size.width * imageSize.height/imageSize.width
    }
    
    
    // refresh layout
    private func refreshLayout(row: Int, col: Int) {
        currentRow = row
        currentCol = col
        
        divideImages?.removeAll()
        divideImages = nil
        divideImages = image.divide(row: currentRow, col: currentCol)
        previewCollectionView.reloadData()
    }
    
    private func setupNavItem() {
        let b = UIBarButtonItem(title: "resize", style: .plain, target: self, action:#selector(showPickerView))
        self.navigationItem.rightBarButtonItem = b
    }
    
    @objc private func showPickerView() {
        view.addSubview(pickerView)
        pickerView.show()
    }

    
    // MARK: ==private method==
    // 重新选择
    @objc private func repickerClick(){
        let pickerVC = UIImagePickerController.init()
        pickerVC.sourceType = .savedPhotosAlbum
        pickerVC.delegate = self
        pickerVC.delegate = self
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    //判断是否授权
    func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    // 保存到相册
    @objc private func saveClick(){
        let delay = DispatchTime.now() + 0.1
        var isShowing = false
        HUD.flash(.label("保存中。。。"), onView: self.view)
        
        for img in self.divideImages! {
            
            //方法调用
            self.saveImageInAlbum(image: img, albumName: "Album-YY分图") { (result) in
                
                if isShowing == true {
                    return
                }
                isShowing = true
                
                var resultString: String!
                switch result{
                    case .success:
                        resultString = "保存成功"
                    case .denied:
                        resultString = "被拒绝"
                    case .error:
                        resultString = "保存错误"
                    }
                
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    HUD.flash(.label(resultString), onView: self.view, delay: 2.0, completion: nil)
                    let delay = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                        isShowing = false
                    })
                }
            }
        }
    }
    
    //保存图片到相册
    func saveImageInAlbum(image: UIImage, albumName: String = "", completion: ((_ result: PhotoAlbumUtilResult) -> ())?) {
        
        //权限验证
        if !isAuthorized() {
            completion?(.denied)
            return
        }
        
        var assetAlbum: PHAssetCollection?
        //如果没有传相册的名字，则保存到相机胶卷。（否则保存到指定相册）
        if albumName.isEmpty {
            yyLog("没有传相册的名字")
        }else {
            //看保存的指定相册是否存在
            let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            
            list.enumerateObjects({ (album, index, stop) in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            })
            
            //不存在的话则创建该相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    self.saveImageInAlbum(image: image, albumName: albumName,completion: completion)
                })
                return
            }
        }
        
        //保存图片
        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //是否要添加到相簿
            if !albumName.isEmpty {
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(for:assetAlbum!)
                albumChangeRequset!.addAssets([assetPlaceholder!]  as NSArray)
            }
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                completion?(.success)
            } else{
                print(error!.localizedDescription)
                completion?(.error)
            }
        }
    }
    
    // MARK: ==LAZY ADD==
    private lazy var pickerView: YYNumberPickerView = {
        let picker = YYNumberPickerView.init(frame: view.bounds)
        picker.y = view.height
        picker.block = {(_ row: Int, _ col: Int) in
            
            self.refreshLayout(row: row, col: col)
        }
        return picker
    }()
    
    private lazy var previewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        var pView = UICollectionView(frame: CGRect.init(x: 0, y: 66, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 100), collectionViewLayout: layout)
        pView.backgroundColor = UIColor.white
        pView.dataSource = self
        pView.delegate = self
        pView.register(UINib(nibName: "PreviewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        return pView
    }()
    
    private lazy var rechoiceButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "重新选择", center: CGPoint.init(x: kScreenW/4, y: view.height - 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(repickerClick), for: .touchUpInside)
        return btn
    } ()
    
    private lazy var saveButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "保    存", center: CGPoint.init(x: kScreenW/4*3, y: view.height - 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return btn
    } ()
}



//MARK: ==UICollectionViewDataSource==
extension YYDivideImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = divideImages {
            return (divideImages?.count)!
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PreviewImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreviewImageCollectionViewCell
        cell.previewImageView.image = divideImages![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = divideImages {
            
            let row:CGFloat = CGFloat(pickerView.selectedRow)
            let col:CGFloat = CGFloat(pickerView.selectedCol)
            
            let width: CGFloat = (CGFloat(previewCollectionView.frame.width) - minspace * (col - 1))/col
            let height: CGFloat = (CGFloat(previewCollectionView.frame.height) - minspace * (row - 1))/row
            
            return CGSize(width: width, height: height)
        }else {
            return CGSize.zero
        }
    }
}

// MARK : 打开相册
extension YYDivideImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /// 选中图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 获取原图
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            self.refreshLayout(row: 3, col: 3)
            previewCollectionView.height = view.bounds.size.width * image.size.height/image.size.width
        }
    }
    
    /// 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

