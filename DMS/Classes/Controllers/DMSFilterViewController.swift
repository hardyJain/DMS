//
//  DMSFilterViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 23/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class DMSFilterViewController: UIViewController, SDTreeDelegate {
  
  //IBOutlet
  @IBOutlet weak var treeView: SDTree!
  @IBOutlet var tableViewFilter: UITableView!
  //Textfield
  var txtIdType: SkyFloatingLabelTextFieldWithIcon?
  var txtId: SkyFloatingLabelTextFieldWithIcon?
  var txtDateFrom: SkyFloatingLabelTextFieldWithIcon?
  var txtDateTo: SkyFloatingLabelTextFieldWithIcon?
  var txtPatientName: SkyFloatingLabelTextFieldWithIcon?
  var txtEnterAnnotaion: SkyFloatingLabelTextFieldWithIcon?
  var txtSelectAnnotation: SkyFloatingLabelTextFieldWithIcon?
  var currentTextField: SkyFloatingLabelTextFieldWithIcon?
  var txtDocType: SkyFloatingLabelTextFieldWithIcon?
  //Keyboard Toolbar
  var toolBar = HSToolBar(doneOnly: false)
  //Picker view for textfield
  var pickerViewIdType = UIPickerView()
  var pickerViewDocType = UIPickerView()
  //Date Picker 
  var datePickerFrom: UIDatePicker?
  var datePickerTo: UIDatePicker?
  //Variables
  let idTypeValue = ["UHID", "OPD", "IPD"]
  let docDateType = ["Admission Date", "Discharge Date", "Visit Date"]
  var annotationData = [JSON]()
  var treeData: [TreeNode] = []
  let cloudTagInfo: DMSCloudTagInfo = DMSCloudTagInfo()
  
  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      self.initFilterView()
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
  //Setup Home View
  func initFilterView() {
    //toolbar delegate assign
    self.toolBar.toolBarDelegate = self
    //Pickerview setup
    self.pickerViewIdType.delegate = self
    self.pickerViewIdType.dataSource = self
    self.pickerViewIdType.sizeToFit()
    self.pickerViewIdType.tag = Tag.FilterPicker.idType
    self.pickerViewIdType.showsSelectionIndicator = true
    //Pickerview setup
    self.pickerViewDocType.delegate = self
    self.pickerViewDocType.dataSource = self
    self.pickerViewDocType.tag = Tag.FilterPicker.docType
    self.pickerViewDocType.sizeToFit()
    self.pickerViewDocType.showsSelectionIndicator = true
    //Date picker setup
    self.datePickerFrom = UIDatePicker()
    self.datePickerFrom?.datePickerMode = .date
    self.datePickerFrom?.maximumDate = NSDate() as Date
    self.datePickerFrom?.addTarget(self, action: #selector(onDatePickerFromValueChange(sender:)), for: .valueChanged)
    self.datePickerTo = UIDatePicker()
    self.datePickerTo?.datePickerMode = .date
    self.datePickerTo?.maximumDate = NSDate() as Date
    self.datePickerTo?.addTarget(self, action: #selector(onDatePickerToValueChange(sender:)), for: .valueChanged)
    //fetch Document List
    self.performGetDocumentList()
    self.initExpandTreeView()
  }
  //TreeView Setup
  func initExpandTreeView() {
    self.treeView.sdDelegate = self
    self.treeView.showCheckBox = true
    self.treeView.searchStringBy = SearchBy.startsWith
    treeData = TreeViewLists.LoadInitialData(data: annotationData)
    self.treeView.loadData(data: treeData)
  }
    
  //MARK: - Action Methods
  //Cancel Button Click
  @IBAction func onCancelBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  //Reset Button Click.
  @IBAction func onResetBtn(_ sender: UIButton) {
      self.resetData()
  }
  //Filter Button Click.
  @IBAction func onFIlterBtn(_ sender: UIButton) {
    if self.validateTextField() {
      self.assignValuesToClass()
      self.createCloudTagData()
      self.performFilter()
    }
  }
  //Search on select Document type tree.
  func onSelectAnnotationTextField(sender: UITextField) {
    if let text = sender.text {
      self.treeView.searchForText = text
    }
  }
  //From datepicker value change handler.
  func onDatePickerFromValueChange(sender:UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    txtDateFrom?.text = dateFormatter.string(from: sender.date)
  }
  //To datepicker value change handler.
  func onDatePickerToValueChange(sender:UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    txtDateTo?.text = dateFormatter.string(from: sender.date)
  }
  
  //MARK: - Other Functional Methods
  //Assign filter parameters to cloud tag.
  func createCloudTagData() {
    self.cloudTagInfo.tagDocType = self.treeView.getSelectedTagName()
    self.cloudTagInfo.createCloudTagData()
  }
  
  // w/s request for perform filter.
  func performFilter() {
    Globals.sharedInstance.isPerformedFilter = true
    let params = DMSFilterInfo.getDataDictionaryForWS(Globals.sharedInstance.filterInfo)
    DMSWebRequest.POST(url: Constants.ApiUrls.filter, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: params(), complition: {(result) -> Void in
      print("Result - \(result)")
      self.hideProgress()
      let jsonResult = JSON(result!)
      if let data = jsonResult["data"].dictionary {
        if let searchResult = data["searchResult"]?.array {
          let filterData = DMSFilterList(data: searchResult)
          Globals.sharedInstance.patientList = filterData.patientFilterList
                    Globals.sharedInstance.patientFileData = filterData.patientFileData
          self.dismiss(animated: true, completion: {})
        }
      }
    }, failure: {(error) -> Void in
      if let err = error {
        print("Error - \(err)")
        self.hideProgress()
      }
    })
  }
  
  //w/s request for get documnet list for treeview.
  func performGetDocumentList() {
    DMSWebRequest.GET(url: Constants.ApiUrls.getDocument, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: nil, complition: {(result) -> Void in
      print("Result - \(result)")
      let jsonResult = JSON(result!)
      if let docData = jsonResult["data"].dictionary {
        if let annotationList = docData["lstAnnotations"]?.array {
          self.annotationData = annotationList
          self.treeData = TreeViewLists.LoadInitialData(data: self.annotationData)
          self.treeView.loadData(data: self.treeData)
        }
      }
    }, failure: {(error) -> Void in
      if let err = error {
        print("Error - \(err)")
        self.hideProgress()
      }
    })
  }
  
  //All textfield and selected doctype value assign to filterinfo class.
  func assignValuesToClass() {
    //check if selected id is UHID then assign value to patient id else assign to reference id for OPD and IPD.
    if (txtIdType?.text == idTypeValue[0]) {
      Globals.sharedInstance.filterInfo.patientId = (self.txtId?.text)!
      Globals.sharedInstance.filterInfo.referenceId = ""
      Globals.sharedInstance.filterInfo.fileType = ""
    } else if (txtIdType?.text == idTypeValue[1]) {
      Globals.sharedInstance.filterInfo.referenceId = (txtId?.text)!
      Globals.sharedInstance.filterInfo.fileType = (txtIdType?.text)!
      Globals.sharedInstance.filterInfo.patientId = ""
    } else if (txtIdType?.text == idTypeValue[2]) {
      Globals.sharedInstance.filterInfo.referenceId = (txtId?.text)!
      Globals.sharedInstance.filterInfo.fileType = (txtIdType?.text)!
      Globals.sharedInstance.filterInfo.patientId = ""
    }
    //Assign textfield values to filter info
    Globals.sharedInstance.filterInfo.dateType = (txtDocType?.text)!
    Globals.sharedInstance.filterInfo.selectedIdType = (txtIdType?.text)!
    Globals.sharedInstance.filterInfo.fileAndDateType = (txtDocType?.text)!
    Globals.sharedInstance.filterInfo.dateFrom = (txtDateFrom?.text)!
    Globals.sharedInstance.filterInfo.dateTo = (txtDateTo?.text)!
    Globals.sharedInstance.filterInfo.patientName = (txtPatientName?.text)!
    Globals.sharedInstance.filterInfo.annotationText = (txtEnterAnnotaion?.text)!
    Globals.sharedInstance.filterInfo.docTypeId = self.treeView.getSelectedId() as [AnyObject]
  }
  //Check validation
  func validateTextField() -> Bool {
    //if user entered value into if field then must be select the id type value.
    if txtIdType?.text?.characters.count == 0 && txtId?.text?.characters.count != 0 {
      self.showAlertMessageWithIndex(index: 101)
        return false
    } else {
        return true
    }
  }
  //reset all data when click on reset button.
  func resetData() {
    self.txtId?.text = ""
    self.txtDocType?.text = ""
    self.txtSelectAnnotation?.text = ""
    self.txtEnterAnnotaion?.text = ""
    self.txtPatientName?.text = ""
    self.txtDateTo?.text = ""
    self.txtDateFrom?.text = ""
    self.txtIdType?.text = ""
    Globals.sharedInstance.arrayTagViewData.removeAll()
    Globals.sharedInstance.filterInfo = DMSFilterInfo()
  }
}

//MARK: - Extensions
//MARK: - Tableview Data Source Method.
extension DMSFilterViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if tableView == tableViewFilter {
      return 4
    } else {
      return 1
    }
  }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == tableViewFilter {
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
    } else {
        return 6
    }
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == tableViewFilter {
      switch indexPath.section {
        case 0:
          let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTwoTextTableCellIdentifier, for: indexPath) as! DMSFilterTwoTextTableViewCell
          //Setup TextField
          self.txtIdType = cell.txtContentFirst
          self.txtId = cell.txtContentSecond
          //Assign Placeholder
          self.txtId?.placeholder = "Enter ID"
          self.txtIdType?.placeholder = "Select ID Type"
          self.txtId?.keyboardType = .numberPad
          //Assign Tags
          self.txtIdType?.tag = Tag.Filter.iDType
          self.txtId?.tag = Tag.Filter.idNumber
          //Setup icon
          self.txtId?.iconText = "X"
          self.txtIdType?.iconText = "X"
          //Assign filterinfo class value to textfield if value available.
          if Globals.sharedInstance.filterInfo.patientId.characters.count != 0 {
            self.txtId?.text = Globals.sharedInstance.filterInfo.patientId
          }
          if Globals.sharedInstance.filterInfo.selectedIdType != idTypeValue[0] {
            self.txtId?.text = Globals.sharedInstance.filterInfo.referenceId
          }
          if Globals.sharedInstance.filterInfo.selectedIdType.characters.count != 0 {
            self.txtIdType?.text = Globals.sharedInstance.filterInfo.selectedIdType
          }
        return cell
        case 1:
          let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterRadioTableCellIdentifier, for: indexPath) as! DMSFilterRadioTableViewCell
            //Setup Button
          self.txtDocType = cell.txtDocType
          self.txtDocType?.tag = Tag.Filter.docType
          self.txtDocType?.iconText = "Z"
          if Globals.sharedInstance.filterInfo.fileAndDateType.characters.count != 0 {
            self.txtDocType?.text = Globals.sharedInstance.filterInfo.fileAndDateType
          }
          return cell
          case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTwoTextTableCellIdentifier, for: indexPath) as! DMSFilterTwoTextTableViewCell
            self.txtDateFrom = cell.txtContentFirst
            self.txtDateTo = cell.txtContentSecond
            self.txtDateFrom?.inputView = datePickerFrom
            self.txtDateTo?.inputView = datePickerTo
            self.txtDateFrom?.tag = Tag.Filter.dateFrom
            self.txtDateTo?.tag = Tag.Filter.dateTo
            self.txtDateFrom?.placeholder = "From"
            self.txtDateTo?.placeholder = "To"
            self.txtDateFrom?.iconText = "D"
            self.txtDateTo?.iconText = "D"
            if Globals.sharedInstance.filterInfo.dateFrom.characters.count != 0 {
                self.txtDateFrom?.text = Globals.sharedInstance.filterInfo.dateFrom
            }
            if Globals.sharedInstance.filterInfo.dateTo.characters.count != 0 {
                self.txtDateTo?.text = Globals.sharedInstance.filterInfo.dateTo
            }
            return cell
          default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTableCellIdentifier, for: indexPath) as! DMSFilterTableViewCell
            cell.txtContent.delegate = self
            cell.txtContent.iconFont = UIFont(name: "DMSFont", size: 20)
            switch indexPath.row {
              case 0:
                self.txtPatientName = cell.txtContent
                self.txtPatientName?.placeholder = "Enter Patient Name"
                self.txtPatientName?.iconText = "H"
                self.txtPatientName?.tag = Tag.Filter.patientName
                if
                  Globals.sharedInstance.filterInfo.patientName.characters.count != 0 {
                    self.txtPatientName?.text = Globals.sharedInstance.filterInfo.patientName
                }
                break
              case 1:
                self.txtEnterAnnotaion = cell.txtContent
                self.txtEnterAnnotaion?.placeholder = "Enter Annotation"
                self.txtEnterAnnotaion?.iconText = "E"
                self.txtEnterAnnotaion?.tag = Tag.Filter.annotation
                if Globals.sharedInstance.filterInfo.annotationText.characters.count != 0 {
                  self.txtEnterAnnotaion?.text = Globals.sharedInstance.filterInfo.annotationText
                }
                break
              case 2:
                self.txtSelectAnnotation = cell.txtContent
                self.txtSelectAnnotation?.placeholder = "Search Document"
                self.txtSelectAnnotation?.iconText = "B"
                self.txtSelectAnnotation?.tag = Tag.Filter.annotationSelect
                self.txtSelectAnnotation?.addTarget(self, action: #selector(onSelectAnnotationTextField(sender:)), for: .editingChanged)
                break
              default:
                break
              }
              return cell
          }
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.filterTableCellIdentifier, for: indexPath) as! DMSFilterTableViewCell
        return cell
      }
  }

//MARK: - UITextField Delegate Methods
extension DMSFilterViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //set toolbar above keyboard.
    currentTextField = textField as? SkyFloatingLabelTextFieldWithIcon
    textField.inputAccessoryView = toolBar
    //Check textfield assign related values.
    if textField.tag == Tag.Filter.iDType {
      //Assign textfield input view as picker view.
      textField.inputView = pickerViewIdType
      textField.text = idTypeValue[0]
      //toolbar button enable/disable.
      toolBar.btnNext.isEnabled = true
      toolBar.btnPrevious.isEnabled = false
    } else if textField.tag == Tag.Filter.docType {
      textField.inputView = pickerViewDocType
      textField.text = docDateType[0]
    } else if textField.tag == Tag.Filter.dateFrom {
      if (txtDateTo?.text?.characters.count)! != 0 {
        let maxdate = Utility.convertDateStringToDate(date:self.txtDateTo?.text, formatter: "dd-MM-yyyy")
        self.datePickerFrom?.maximumDate = maxdate as Date?
      } else {
        self.datePickerFrom?.maximumDate = Date()
      }
    } else if textField.tag == Tag.Filter.dateTo {
        if (txtDateFrom?.text?.characters.count)! != 0 {
          let minDate = Utility.convertDateStringToDate(date: self.txtDateFrom?.text, formatter: "dd-MM-yyyy")
          self.datePickerTo?.minimumDate = minDate as Date?
        } else {
          self.datePickerTo?.maximumDate = Date()
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
    if textField.tag == Tag.Filter.idNumber {
      let characterSet = NSCharacterSet.decimalDigits.inverted
      let validString = string.components(separatedBy: characterSet).joined(separator: "")
      return string == validString
    } else if textField.tag == Tag.Filter.dateFrom {
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

//MARK: - Toolbar delegate methods
extension DMSFilterViewController: HSToolbarDelegate {
  func onMovePrevious(sender: UIButton) {
    if txtSelectAnnotation!.isEditing {
      txtEnterAnnotaion!.becomeFirstResponder()
    } else if txtEnterAnnotaion!.isEditing {
      txtPatientName?.becomeFirstResponder()
    } else if txtPatientName!.isEditing {
      txtDateTo?.becomeFirstResponder()
    } else if txtDateTo!.isEditing {
      txtDateFrom?.becomeFirstResponder()
    } else if txtDateFrom!.isEditing {
      txtDocType?.becomeFirstResponder()
    } else if txtDocType!.isEditing {
      txtId?.becomeFirstResponder()
    } else if txtId!.isEditing {
      txtIdType?.becomeFirstResponder()
    }
  }
    
  func onMoveNext(sender: UIButton) {
    if txtIdType!.isEditing {
      txtId!.becomeFirstResponder()
    } else if txtId!.isEditing {
      txtDocType!.becomeFirstResponder()
    } else if txtDocType!.isEditing {
      txtDateFrom!.becomeFirstResponder()
    } else if txtDateFrom!.isEditing {
      txtDateTo!.becomeFirstResponder()
    } else if txtDateTo!.isEditing {
      txtPatientName!.becomeFirstResponder()
    } else if txtPatientName!.isEditing {
      txtEnterAnnotaion!.becomeFirstResponder()
    } else if txtEnterAnnotaion!.isEditing {
      txtSelectAnnotation!.becomeFirstResponder()
    }
  }
    
  func onToolbarDone(sender: UIButton) {
    currentTextField!.resignFirstResponder()
  }
}

//MARK: - PickerView Datasource methods
extension DMSFilterViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    switch pickerView.tag {
      case Tag.FilterPicker.idType:
        return 1
      case Tag.FilterPicker.docType:
        return 1
      default:
        return 1
      }
  }
    
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView.tag {
      case Tag.FilterPicker.idType:
        return idTypeValue.count
      case Tag.FilterPicker.docType:
        return docDateType.count
      default:
        return 1
      }
  }
    
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView.tag {
      case Tag.FilterPicker.idType:
        return idTypeValue[row]
      case Tag.FilterPicker.docType:
        return docDateType[row]
      default:
        return ""
    }
  }
}

//MARK: - PickerView delegate methods
extension DMSFilterViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView.tag {
      case Tag.FilterPicker.idType:
        self.txtIdType?.text = idTypeValue[row]
      case Tag.FilterPicker.docType:
        self.txtDocType?.text = docDateType[row]
      default:
        break
    }
  }
}
