//
//  YYNumberPickerView.swift
//  PickView
//
//  Created by yejunyou on 2018/5/19.
//  Copyright © 2018年 futureversion. All rights reserved.
//

import UIKit
import UIView_Positioning

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
        
        let bgView: UIView = UIView.init()
        bgView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        bgView.backgroundColor = UIColor.red
        bgView.alpha = 0.3
        addSubview(bgView)
        
        pickerView = UIPickerView.init()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.yellow
        
        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(2, inComponent: 1, animated: true)

        let h: CGFloat = 150
        pickerView.frame = CGRect.init(x: 0, y: 150, width: self.width, height: h)
        addSubview(pickerView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        addGestureRecognizer(tap)
    }
    
    // MARK: 确认点击
    @objc func tapClick() {
        UIView.animate(withDuration: 0.5) {
            self.y = self.height
            
        }
        
        if let _ = block {
            block(selectedRow, selectedCol)
//            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// show
    public func show() {
        UIView.animate(withDuration: 0.5) {
            self.y = 0
//            self.alpha = 1.0
            yyLog("\(self.frame) --- \(self.pickerView.frame)")
        }
    }
    
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
        return 50
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
