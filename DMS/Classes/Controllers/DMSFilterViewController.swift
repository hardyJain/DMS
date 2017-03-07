//
//  DMSFilterViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 23/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import  RATreeView

class DMSFilterViewController: UIViewController {
    //IBOutlet
    @IBOutlet var treeView: RATreeView!
    @IBOutlet var tableViewFilter: UITableView!
    var txtIdType: SkyFloatingLabelTextFieldWithIcon?, txtId: SkyFloatingLabelTextFieldWithIcon?, txtDateFrom: SkyFloatingLabelTextFieldWithIcon?, txtDateTo: SkyFloatingLabelTextFieldWithIcon?, txtPatientName: SkyFloatingLabelTextFieldWithIcon?, txtEnterAnnotaion: SkyFloatingLabelTextFieldWithIcon?, txtSelectAnnotation: SkyFloatingLabelTextFieldWithIcon?, currentTextField: SkyFloatingLabelTextFieldWithIcon?, txtDocType: SkyFloatingLabelTextFieldWithIcon?
    var btnRadioOPD: UIButton?, btnRadioIPD: UIButton? = nil
    var toolBar = HSToolBar(doneOnly: false)
    var pickerViewIdType = UIPickerView()
    var pickerViewDocType = UIPickerView()

    var datePickerFrom: UIDatePicker?
    var datePickerTo: UIDatePicker?
    
    let arrayTreeContent = ["Hardik","Jain","iOS","DMS","Pune","awdw"]
    
    //Variables
    let idTypeValue = ["UHID", "Reference ID"]
    let docTypeValue = ["IPD","OPD"]
    let docDateType = ["Admission Date", "Discharge Date", "Visit Date"]
    var docValue: String?
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initFilterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Init home view
    func initFilterView() {
        self.toolBar.toolBarDelegate = self
        self.pickerViewIdType.delegate = self
        self.pickerViewIdType.dataSource = self
        self.pickerViewIdType.sizeToFit()
        self.pickerViewIdType.tag = Tag.FilterPicker.idType
        self.pickerViewIdType.showsSelectionIndicator = true
        
        self.pickerViewDocType.delegate = self
        self.pickerViewDocType.dataSource = self
        self.pickerViewDocType.tag = Tag.FilterPicker.docType
        self.pickerViewDocType.sizeToFit()
        self.pickerViewDocType.showsSelectionIndicator = true
        
        self.datePickerFrom = UIDatePicker()
        self.datePickerFrom?.datePickerMode = .date
        self.datePickerFrom?.maximumDate = NSDate() as Date
        self.datePickerFrom?.addTarget(self, action: #selector(onDatePickerFromValueChange(sender:)), for: .valueChanged)
        self.datePickerTo = UIDatePicker()
        self.datePickerTo?.datePickerMode = .date
        self.datePickerTo?.maximumDate = NSDate() as Date
        self.datePickerTo?.addTarget(self, action: #selector(onDatePickerToValueChange(sender:)), for: .valueChanged)
        
        self.treeView.delegate = self
        self.treeView.dataSource = self
//        let nib = UINib(nibName: "DMSFilterExpandTableViewCell", bundle: nil)
        self.treeView.register(UINib(nibName: String("DMSFilterExpandTableViewCell"), bundle: nil), forCellReuseIdentifier: String(Constants.TableViewCellIdentifiers.filterExpandTableCellIdentifier))
    }
    
    //MARK: - IBAction Methods
    @IBAction func onCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func onResetBtn(_ sender: UIButton) {
        self.resetData()
    }
    
    @IBAction func onFIlterBtn(_ sender: UIButton) {
    
    }
    //MARK: - Other Functional Methods
    func resetData() {
        self.txtId?.text = ""
        self.txtSelectAnnotation?.text = ""
        self.txtEnterAnnotaion?.text = ""
        self.txtPatientName?.text = ""
        self.txtDateTo?.text = ""
        self.txtDateFrom?.text = ""
        self.txtIdType?.text = ""
    }
    
    func onRadioBtnOPD(sender: UIButton) {
        sender.isSelected = true
        self.btnRadioIPD?.isSelected = false
    }
    
    func onRadioBtnIPD(sender: UIButton) {
        sender.isSelected = true
        self.btnRadioOPD?.isSelected = false
    }
    
    func onDatePickerFromValueChange(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDateFrom?.text = dateFormatter.string(from: sender.date)
    }
    
    func onDatePickerToValueChange(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDateTo?.text = dateFormatter.string(from: sender.date)
    }
}

//MARK: - Extensions

extension DMSFilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTwoTextTableCellIdentifier, for: indexPath) as! DMSFilterTwoTextTableViewCell
    
            //Setup TextField
            self.txtIdType = cell.txtContentFirst
            self.txtId = cell.txtContentSecond
            
            //Assign Placeholder
            self.txtId?.placeholder = "Enter ID"
            self.txtIdType?.placeholder = "Select ID Type"
            
            //Assign Tags
            self.txtIdType?.tag = Tag.Filter.iDType
            self.txtId?.tag = Tag.Filter.idNumber
            
            //Setup Iconfont & icon
            self.txtId?.iconFont = UIFont(name: "DMSFont", size: 17)
            self.txtIdType?.iconFont = UIFont(name: "DMSFont", size: 17)
            self.txtId?.iconText = "K"
            self.txtIdType?.iconText = "K"
            
            //Setup delegate
            self.txtIdType?.delegate = self
            self.txtId?.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterRadioTableCellIdentifier, for: indexPath) as! DMSFilterRadioTableViewCell
            //Setup Button
            self.txtDocType = cell.txtDocType
            self.txtDocType?.tag = Tag.Filter.docType
            self.txtDocType?.iconFont = UIFont(name: "DMSFont", size: 17)
            self.txtDocType?.iconText = "h"
            self.txtDocType?.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTwoTextTableCellIdentifier, for: indexPath) as! DMSFilterTwoTextTableViewCell
            self.txtDateFrom = cell.txtContentFirst
            self.txtDateTo = cell.txtContentSecond
            self.txtDateFrom?.delegate = self
            self.txtDateTo?.delegate = self
            self.txtDateFrom?.inputView = datePickerFrom
            self.txtDateTo?.inputView = datePickerTo
            self.txtDateFrom?.tag = Tag.Filter.dateFrom
            self.txtDateTo?.tag = Tag.Filter.dateTo

            self.txtDateFrom?.placeholder = "From"
            self.txtDateTo?.placeholder = "To"
            self.txtDateFrom?.iconFont = UIFont(name: "DMSFont", size: 17)
            self.txtDateTo?.iconFont = UIFont(name: "DMSFont", size: 17)
            self.txtDateFrom?.iconText = "C"
            self.txtDateTo?.iconText = "C"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTableCellIdentifier, for: indexPath) as! DMSFilterTableViewCell
            cell.txtContent.delegate = self
            cell.txtContent.iconFont = UIFont(name: "DMSFont", size: 17)
            switch indexPath.row {
            case 0:
                self.txtPatientName = cell.txtContent
                self.txtPatientName?.placeholder = "Enter Patient Name"
                self.txtPatientName?.iconText = "u"
                self.txtPatientName?.tag = Tag.Filter.patientName
                break
            case 1:
                self.txtEnterAnnotaion = cell.txtContent
                self.txtEnterAnnotaion?.placeholder = "Enter Annotation"
                self.txtEnterAnnotaion?.iconText = "A"
                self.txtEnterAnnotaion?.tag = Tag.Filter.annotation
                break
            case 2:
                self.txtSelectAnnotation = cell.txtContent
                self.txtSelectAnnotation?.placeholder = "Search Annotation"
                self.txtSelectAnnotation?.iconText = "S"
                self.txtSelectAnnotation?.tag = Tag.Filter.annotationSelect
                break
            default:
                break
            }
            return cell
        }
    }
}

extension DMSFilterViewController: UITableViewDelegate {

}

//UITextField Delegate Methods
extension DMSFilterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField as? SkyFloatingLabelTextFieldWithIcon
        textField.inputAccessoryView = toolBar
        if textField.tag == Tag.Filter.iDType {
            textField.inputView = pickerViewIdType
            toolBar.btnNext.isEnabled = true
            toolBar.btnPrevious.isEnabled = false
        } else if textField.tag == Tag.Filter.docType {
            textField.inputView = pickerViewDocType
            toolBar.btnNext.isEnabled = true
            toolBar.btnPrevious.isEnabled = true
        } else if textField.tag == Tag.Filter.dateFrom {
            if (txtDateTo?.text?.characters.count)! != 0 {
                let maxdate = Utility.convertDateStringToDate(date: txtDateTo?.text)
                self.datePickerFrom?.maximumDate = maxdate as Date?
            }
        } else if textField.tag == Tag.Filter.dateTo {
            if (txtDateFrom?.text?.characters.count)! != 0 {
                let minDate = Utility.convertDateStringToDate(date: txtDateFrom?.text)
                self.datePickerTo?.minimumDate = minDate as Date?
            }
        } else if textField.tag == Tag.Filter.annotationSelect {
            toolBar.btnNext.isEnabled = false
            toolBar.btnPrevious.isEnabled = true
        } else {
            toolBar.btnNext.isEnabled = true
            toolBar.btnPrevious.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == Tag.Filter.dateFrom {
            return false
        } else if textField.tag == Tag.Filter.dateTo {
            return false
        } else if textField.tag == Tag.Filter.iDType {
            return false
        } else if textField.tag == Tag.Filter.docType {
            return false
        } else {
            return true
        }
    }
}

//Toolbar delegate methods
extension DMSFilterViewController: HSToolbarDelegate {
    func onMovePrevious(sender: UIButton) {
        if txtSelectAnnotation!.isEditing {
            txtEnterAnnotaion!.becomeFirstResponder()
        } else if (txtEnterAnnotaion?.isEditing)! {
            txtPatientName?.becomeFirstResponder()
        } else if (txtPatientName?.isEditing)! {
            txtDateTo?.becomeFirstResponder()
        } else if (txtDateTo?.isEditing)! {
            txtDateFrom?.becomeFirstResponder()
        } else if (txtDateFrom?.isEditing)! {
            txtId?.becomeFirstResponder()
        } else if (txtId?.isEditing)! {
            txtIdType?.becomeFirstResponder()
        }
    }
    
    func onMoveNext(sender: UIButton) {
        if txtIdType!.isEditing {
            txtId!.becomeFirstResponder()
        } else if (txtId?.isEditing)! {
            txtDateFrom?.becomeFirstResponder()
        } else if (txtDateFrom?.isEditing)! {
            txtDateTo?.becomeFirstResponder()
        } else if (txtDateTo?.isEditing)! {
            txtPatientName?.becomeFirstResponder()
        } else if (txtPatientName?.isEditing)! {
            txtEnterAnnotaion?.becomeFirstResponder()
        } else if (txtEnterAnnotaion?.isEditing)! {
            txtSelectAnnotation?.becomeFirstResponder()
        }
    }
    
    func onToolbarDone(sender: UIButton) {
        currentTextField!.resignFirstResponder()
    }
}

extension DMSFilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case Tag.FilterPicker.idType:
            return 1
        case Tag.FilterPicker.docType:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case Tag.FilterPicker.idType:
            return idTypeValue.count
        case Tag.FilterPicker.docType:
            switch component {
            case 0:
                return docTypeValue.count
            case 1:
                return docDateType.count
            default:
                return 0
            }
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case Tag.FilterPicker.idType:
            return idTypeValue[row]
        case Tag.FilterPicker.docType:
            switch component {
            case 0:
                return docTypeValue[row]
            case 1:
                return docDateType[row]
            default:
                return ""
            }
        default:
            return ""
        }
        
    }
}

extension DMSFilterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tag.FilterPicker.idType:
            self.txtIdType?.text = idTypeValue[row]
        case Tag.FilterPicker.docType:
            switch component {
            case 0:
                self.docValue = docTypeValue[row]
                self.txtDocType?.text = self.docValue //docTypeValue[row]
            case 1:
                let dateVal = docDateType[row]
                self.txtDocType?.text = self.docValue! + " - " + dateVal
            default:
                break
            }
        default:
            break
        }
    }
}

extension DMSFilterViewController: RATreeViewDataSource {
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        return 1
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
       
        let cell = treeView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterExpandTableCellIdentifier) as? DMSFilterExpandTableViewCell
        
        cell?.lblTitle.text = "Document"
        return cell!
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        return arrayTreeContent[index]
    }
}

extension DMSFilterViewController: RATreeViewDelegate {
    
}

