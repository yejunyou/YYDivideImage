//
//  YYNumberPickerView.swift
//  PickView
//
//  Created by yejunyou on 2018/5/19.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import UIView_Positioning

class YYNumberPickerView: UIView  {
    typealias PickerCompleteBlock = (_ row: Int,_ col: Int) ->()
    var block: PickerCompleteBlock!
    
//    var pickerView: UIPickerView!
    var dataList: [String]!
    public var selectedRow: Int!
    public var selectedCol: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectedRow = 3
        selectedCol = 3

        dataList = Array.init()
        for i in 1...10 {
            dataList.append("\(i)")
        }
        
        addSubview(bgView)
        addSubview(pickerView)
        addSubview(confirmButton)
        addSubview(cancelButton)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenClick))
        addGestureRecognizer(tap)
    }
    
    // MARK: 确认点击
    @objc func tapClick() {
        UIView.animate(withDuration: 0.25) {
            self.y = self.height
        }
        
        if let _ = block {
            block(selectedRow, selectedCol)
//            self.removeFromSuperview()
        }
    }
    
    @objc func hiddenClick() {
        UIView.animate(withDuration: 0.25) {
            self.y = self.height
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// show
    public func show() {
        UIView.animate(withDuration: 0.25) {
            self.y = 0
        }
    }
    
    //MARK: == lazy add
    private lazy var bgView: UIView = {
        let bgView: UIView = UIView.init()
        bgView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.7
        return bgView
    } ()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView.init()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = kColorHex(0x0a60fe)
        
        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(2, inComponent: 1, animated: true)
        
        pickerView.frame = CGRect.init(x: 0, y: 150, width: self.width, height: 150)
        return pickerView
    } ()
    
    private lazy var confirmButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "确定", center: CGPoint.init(x: kScreenW/4*3, y: pickerView.bottom + 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return btn
    } ()
    
    private lazy var cancelButton: UIButton = {
        var btnW: CGFloat = 120
        var btnX: CGFloat = (kScreenW - btnW)/2
        let btn = UIButton.init(title: "取消", center: CGPoint.init(x: kScreenW/4, y: pickerView.bottom + 50), style: .simpleBlueStyle)
        btn.addTarget(self, action: #selector(hiddenClick), for: .touchUpInside)
        return btn
    } ()
}

extension YYNumberPickerView:  UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: data source method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: dataList[row])
    }
    
    // row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    // selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yyLog("\(component)" + "-" + "\(dataList[row])")
        if component == 0 {
            selectedRow = Int(dataList[row])
        } else {
            selectedCol = Int(dataList[row])
        }
    }
}
