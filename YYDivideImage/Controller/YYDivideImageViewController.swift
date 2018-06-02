//
//  YYDivideImageViewController.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import Photos

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
        layout()
        setupNavItem()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
    
    private func layout(){
        
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
    
    // 保存到相册
    @objc private func saveClick(){
        for var img in divideImages! {
//            UIImageWriteToSavedPhotosAlbum(img, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
            PHPhotoLibrary.shared().performChanges({
                let result = PHAssetChangeRequest.creationRequestForAsset(from: img)
                let assetPlaceholder = result.placeholderForCreatedAsset
                //保存标志符
                self.localId = assetPlaceholder?.localIdentifier
            }) { (isSuccess: Bool, error: Error?) in
                if isSuccess {
                    yyLog("保存成功!")
                    //通过标志符获取对应的资源
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [self.localId!], options: nil)
                    let asset = assetResult[0]
                    let options = PHContentEditingInputRequestOptions()
                    options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                        -> Bool in
                        return true
                    }
                    //获取保存的图片路径
                    asset.requestContentEditingInput(with: options, completionHandler: {
                        (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
                        print("地址：",contentEditingInput!.fullSizeImageURL!)
                    })
                } else{
                    print("保存失败：", error!.localizedDescription)
                }
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
            yyLog(divideImages?.count)
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
            
//            yyLog("return CGSize(width: \(width), height: \(height)")
            return CGSize(width: width, height: height)
        }else {
            yyLog("return CGSize.zero")
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

