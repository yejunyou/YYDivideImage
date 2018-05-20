//
//  YYDivideImageViewController.swift
//  YYDivideImage
//
//  Created by yejunyou on 2018/5/16.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit

class YYDivideImageViewController: UIViewController,UICollectionViewDelegate {
    
    private var image: UIImage
    private var divideImages: [UIImage]?
    private var currentCol: Int!
    private var currentRow: Int!
    private var imageCount: Int?
    
    // view
//    private var previewCollectionView: UICollectionView!
    private let minspace: CGFloat = 3
    
    // MARK: init ==method==
    init(image: UIImage) {
        self.image = image
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
        view.backgroundColor = UIColor.gray
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
    }
    
    
    // refresh layout
    private func refreshLayout(row: Int, col: Int) {
        currentRow = row
        currentCol = col
        
        divideImages?.removeAll()
        divideImages = nil
        divideImages = image.divide(row: pickerView.selectedRow, col: pickerView.selectedCol)
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
    
    // MARK: ==LAZY ADD==
    private lazy var pickerView: YYNumberPickerView = {
        let picker = YYNumberPickerView.init(frame: view.bounds)
        picker.y = view.height
        picker.block = {(_ row: Int, _ col: Int) in
            
            print("row = \(row) col = \(col)")
            self.refreshLayout(row: row, col: col)
//            self.previewCollectionView.reloadData()
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
}



//MARK: ==UICollectionViewDataSource==
extension YYDivideImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        yyLog("--")
        if let _ = divideImages {
            yyLog(divideImages?.count)
            return (divideImages?.count)!
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        yyLog("return 1")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PreviewImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreviewImageCollectionViewCell
        cell.previewImageView.image = divideImages![indexPath.item]
        yyLog("return cell")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = divideImages {
            
            let row:CGFloat = CGFloat(pickerView.selectedRow)
            let col:CGFloat = CGFloat(pickerView.selectedCol)

            let width: CGFloat = (CGFloat(previewCollectionView.frame.width) - minspace * (col - 1))/col
            let height: CGFloat = (CGFloat(previewCollectionView.frame.height) - minspace * (row - 1))/row
            
            yyLog("return CGSize(width: width / count, height: height / count)")
            return CGSize(width: width, height: height)
        }else {
            yyLog("return CGSize.zero")
            return CGSize.zero
        }
    }
}
func yyLog<T>(_ message:T, file:String = #file, function:String = #function,
              line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\(fileName):\(line) \(function) | \(message)")
    #endif
}
