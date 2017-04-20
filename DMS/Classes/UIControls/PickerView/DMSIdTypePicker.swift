//
//  DMSIdTypePicker.swift
//  DMS
//
//  Created by Scorg Technologies on 24/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

@objc protocol DMSIdtypePickerDelegate {
    func onPickerDidSelectItem(sender:DMSIdTypePicker?, atIndex index:Int, withTitle title:String?)
}

class DMSIdTypePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let idTypeList: Array<String> = ["UHID", "Reference ID"]
    private var selIndex:Int = 0
    
    var pickerDelegate:DMSIdtypePickerDelegate?
    
    var selectedIndex:Int {
        get {
            return self.selIndex
        }
        set {
            if newValue < 0 {
                self.selIndex = 0
            }
            else if newValue >= idTypeList.count {
                self.selIndex = idTypeList.count - 1
            }
            else {
                self.selIndex = newValue
            }
            self.selectRow(self.selIndex, inComponent: 0, animated: true)
        }
    }
    
    var selectedItem:String {
        get {
            return self.idTypeList[self.selIndex]
        }
        set {
            if newValue.characters.count > 0 {
                self.selectedIndex = self.idTypeList.index(of: newValue)!
            }
            else {
                self.selectedIndex = 0
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.initPickerView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initPickerView()
    }
    
    func initPickerView() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor.white
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func numberOfRows(inComponent component: Int) -> Int {
        return self.idTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.idTypeList[row]
    }
}
