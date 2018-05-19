//
//  YYNumberPickerView.swift
//  PickView
//
//  Created by yejunyou on 2018/5/19.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit

class YYNumberPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource  {
    typealias PickerCompleteBlock = (_ row: Int,_ col: Int) ->()
    var block: PickerCompleteBlock!
    
    var pickerView: UIPickerView!
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
        
        pickerView = UIPickerView.init()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.yellow
        
        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(2, inComponent: 1, animated: true)
        
        let h: CGFloat = 150
        
        pickerView.frame = CGRect.init(x: 0, y: frame.size.height, width: frame.size.width, height: h)
        addSubview(pickerView)
        
        backgroundColor = UIColor.gray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        addGestureRecognizer(tap)
    }
    
    @objc func tapClick() {
        UIView.animate(withDuration: 0.5) {
            self.pickerView.frame = CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
            self.alpha = 0
        }
        
        if let _ = block {
            block(selectedRow, selectedCol)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        UIView.animate(withDuration: 0.5) {
            let h: CGFloat = 150
            let y: CGFloat = self.frame.size.height - h
            self.pickerView.frame = CGRect.init(x: 0, y: y, width: self.frame.size.width, height: h)
            self.alpha = 1.0
        }
    }
    
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
        return 50
    }
    
    // selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(component)" + "-" + "\(dataList[row])")
        if component == 0 {
            selectedRow = Int(dataList[row])
        } else {
            selectedCol = Int(dataList[row])
        }
    }
}
