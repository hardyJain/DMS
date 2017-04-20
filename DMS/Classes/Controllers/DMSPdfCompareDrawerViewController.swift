//
//  DMSPdfCompareOptionsViewController.swift
//  DMS
//
//  Created by Swapnil Dhotre on 14/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SlideMenuControllerSwift

class DMSPdfCompareDrawerViewController: UIViewController {
  //IBOutlet
  @IBOutlet weak var scrollableSwitch: UISwitch!
  @IBOutlet weak var labelScrollableBoth: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var treeView: SDTree!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  //Variables
  var pdfArchivedRecords: [PdfFileArchivedDetails] = []
  var apiArchivedData: JSON?
  var patientInfo: [CellRecords] = []
  var fileOne: [CellRecords] = []
  var fileTwo: [CellRecords] = []
  var array: [Sections] = []
  var data: [TreeNode] = []
  
  //MARK: - Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.setUIAppearance()
    if let slideController = self.slideMenuController() {
      slideController.delegate = self
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    if let slideController = self.slideMenuController() {
      slideController.removeRightGestures()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - Action Methods
  //switch button handler
  @IBAction func switchChanged(_ sender: UISwitch) {
    Globals.sharedInstance.isPdfScrollable = sender.isOn
  }
    
  //MARK: - Custom Methods
  func setUIAppearance() {
    if Globals.sharedInstance.archivedData.count > 1 {
      self.labelScrollableBoth.text = "Scrollable Both"
      self.scrollableSwitch.isHidden = false
    } else {
      self.labelScrollableBoth.text = ""
      self.scrollableSwitch.isHidden = true
    }
  }
    
  func setDrawerIcons(forCell cell: DMSOptionsInfoTableViewCell, section: Int, row: Int) {
    if section == 0 && row == 0 {
      cell.labelIcon.text = "A"
    } else if section == 0 && row == 1 {
      cell.labelIcon.text = "X"
    } else if section == 0 && row == 2 {
      cell.labelIcon.text = "Y"
    } else if (section == 1 || section == 2) && row == 0 {
      cell.labelIcon.text = "a"
    } else if (section == 1 || section == 2) && row == 1 {
      cell.labelIcon.text = "D"
    } else if (section == 1 || section == 2) && row == 0 {
      cell.labelIcon.text = "D"
    }
  }
    
  func getDocTypedMatchedInAnotherFile(withTypeName typeName: String, tappedIndexObject fileIndex: Int) -> [String: Any]? {
    guard let apiArchived = self.apiArchivedData else {
      return nil
    }
    var loopIndex = 0
    for (_,archivedData) in apiArchived {
      loopIndex += 1
      if loopIndex == fileIndex {
        continue
      }
      for (_, listDocCategories) in archivedData["lstDocCategories"] {
        for (_, docTypeObject) in listDocCategories["lstDocTypes"] {
          if (docTypeObject["typeName"].string ?? "") == typeName {
            let docObject: [String : Any] = ["typeId" : docTypeObject["typeId"].int ?? 0, "typeName" : docTypeObject["typeName"].string ?? "", "pageCount" : docTypeObject["pageCount"].int ?? 0, "pageNumber" : (docTypeObject["pageNumber"].int ?? 0) - 1, "abbreviation" : docTypeObject["abbreviation"].string ?? "", "createdDate" : docTypeObject["createdDate"].string ?? "" ]
            return docObject
          }
        }
      }
      print("Print SOmething to check")
    }
    return nil
  }
    
  func reloadView() {
    self.initCellData()
    self.setTableViewProperties()
    self.registerNibFiles()
  }
  
  func registerNibFiles() {
    let headerNib = UINib(nibName: "DMSPdfComparisonOptionsHeaderView", bundle: nil)
    self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: Constants.Nib.optionsHeaderIdentifier)
    let footerNib = UINib(nibName: "DMSPdfComparisonFooterView", bundle: nil)
    self.tableView.register(footerNib, forCellReuseIdentifier: Constants.Nib.optionsFooterIdentifier)
  }
    
  func initCellData() {
    self.pdfArchivedRecords = Globals.sharedInstance.archivedData
    self.getArchivedDataFromApi()
    if self.pdfArchivedRecords.count > 0 {
      self.patientInfo = []
      self.patientInfo.append( CellRecords(icon: "", key: self.pdfArchivedRecords[0].patientName, value: "", encircled: false) )
      self.patientInfo.append( CellRecords(icon: "", key: "UHID", value: self.pdfArchivedRecords[0].patientId, encircled: true) )
      self.patientInfo.append( CellRecords(icon: "", key: self.pdfArchivedRecords[0].location, value: "", encircled: false) )
    }
    self.fileOne = []
    self.fileTwo = []
    for (index, object) in self.pdfArchivedRecords.enumerated() {
      let cell1 = CellRecords(icon: "", key: "REF ID", value: object.referenceId, encircled: true)
      let cell2 = CellRecords(icon: "", key: "Doctor", value: object.doctorName, encircled: false)
      let cell3 = CellRecords(icon: "", key: "Admission", value: object.admissionDate, encircled: false)
      let cell4 = CellRecords(icon: "", key: "Discharge", value: object.dischargeDate, encircled: false)
      if index == 0 {
        self.fileOne = [cell1, cell2, cell3, cell4]
      } else {
        self.fileTwo = [cell1, cell2, cell3, cell4]
      }
    }
    self.array = []
    self.array.append(Sections(header: "Patient Informations", badgeString: "", objects: self.patientInfo))
    self.array.append(Sections(header: Globals.sharedInstance.archivedData.count > 1 ? "File-One" : "File", badgeString: "IPD", objects: fileOne))
    //This condition is checked for Second file if only single file is selected
    if fileTwo.count > 0 {
      self.array.append(Sections(header: "File-Two", badgeString: "IPD", objects: fileTwo))
    }
    self.tableView.reloadData()
  }
    
  func setTableViewProperties() {
    self.treeView.sdDelegate = self
    self.treeView.makeCellClickable = true
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.allowsSelection = false
    if self.fileTwo.count > 0 {
      self.tableViewHeightConstraint.constant = 500
    } else {
      self.tableViewHeightConstraint.constant = 300
    }
  }
    
  func getDataDictionaryForArchived(archivedObjects: [PdfFileArchivedDetails]) -> Parameters {
    let array = NSMutableArray()
    for archivedObject in archivedObjects {
      let object = [
        "patientId": archivedObject.patientId,
        "fileType": archivedObject.fileType,
        "fileTypeRefId": archivedObject.referenceId
      ]
      array.add(object)
    }
    let param: Parameters = ["lstSearchParam": array]
    return param
  }
    
  func getArchivedDataFromApi() {
    self.showProgress(status: "Loading...")
    var params: Parameters = [:]
    if self.pdfArchivedRecords.count > 0 {
      params = self.getDataDictionaryForArchived(archivedObjects: self.pdfArchivedRecords)
    }
    DMSWebRequest.POST(url: Constants.ApiUrls.archived, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: params as [String : AnyObject]?, complition: {(result) -> Void in
      self.hideProgress()
      if let data = result {
        let json = JSON(data)
        var pageCount: Int = 0
        var docTypes: [Parameters] = []
        for (_, object) in json["data"]["archiveData"][0]["lstDocCategories"][0]["lstDocTypes"] {
          pageCount += object["pageCount"].int ?? 0
          let object: Parameters = ["typeId": object["typeId"].int ?? 0, "typeName": object["typeName"].string ?? "", "abbreviation": object["abbreviation"].string ?? "", "createdDate": object["createdDate"].string ?? "", "pageCount": object["pageCount"].int ?? 0, "pageNumber": object["pageNumber"].int ?? 0
          ]
          docTypes.append(object)
        }
        let listDocCategory = json["data"]["archiveData"]
        self.apiArchivedData = listDocCategory
        self.setTableViewData(archivedObjects: listDocCategory)
      }
    }, failure: {(error) -> Void in
      if let err = error {
        self.hideProgress()
        self.showAlert(message: "\(err)")
      }
    })
  }
    
  func setTableViewData(archivedObjects: JSON) {
    var data: [TreeNode] = []
    var counter = 0
    self.treeView.loadData(data: [])
    if archivedObjects.count == 2 && archivedObjects[0]["fileType"].stringValue == archivedObjects[1]["fileType"].stringValue {
      self.mergeTreeJsonData(archivedObjects: archivedObjects)
    } else {
      var categoriesTotal: Int = 0
      for (_, archivedObject) in archivedObjects {
        counter += 1
        var fileCount = 0
        for (_, listDocObject) in archivedObject["lstDocCategories"] {
          var categoryPageNumber = -1
            for (_, lstDocTypesObject) in listDocObject["lstDocTypes"] {
              let docTypeByFile = self.getDocTypeWithAssociatedPageNumber(fileCounter: counter,docType: lstDocTypesObject)
              let pageCount = (lstDocTypesObject["pageCount"].int ?? 0) == 0 ? "" : "\(lstDocTypesObject["pageCount"].int!)"
                        categoriesTotal += Int(pageCount)!
              if categoryPageNumber == -1 {
                categoryPageNumber = (lstDocTypesObject["pageNumber"].int ?? 0) - 1
              }
              data.append(TreeNode(id: "File\(counter)_\(lstDocTypesObject["typeId"].int ?? 0)", level: 2, title: "\(lstDocTypesObject["typeName"].stringValue) (\(pageCount))", parentId: "File\(counter)_\(listDocObject["categoryId"].int ?? 0)", data: JSON(docTypeByFile), isExpanded: false, pageCount: Int(pageCount)!))
          }
          //Set key according to file in doctypes
          let key = (counter == 1 ? "otherFilePageNumber1" : "otherFilePageNumber2")
          let docObject: [String : Any] = [key: categoryPageNumber]
          data.append(TreeNode(id: "File\(counter)_\(listDocObject["categoryId"].int ?? 0)", level: 1, title: "\(listDocObject["categoryName"].stringValue) (\(categoriesTotal))", parentId: "File\(counter)_\(archivedObject["fileType"].stringValue)", data: JSON(docObject), isExpanded: false, pageCount: categoriesTotal))
                  fileCount += categoriesTotal
        }
        data.append(TreeNode(id: "File\(counter)_\(archivedObject["fileType"].stringValue)", level: 0, title: "\(archivedObject["fileType"].stringValue) (\(fileCount))", parentId: "", data: nil, isExpanded: false, pageCount: counter))
      }
      self.treeView.loadData(data: data)
    }
  }
    
  func mergeTreeJsonData(archivedObjects: JSON) {
    var data: [TreeNode] = []
    var categoriesAdded: [String] = []
    var docTypesAdded: [String] = []
    var categoriesAddedAtPositions: [Int] = []
    var categoriesAddedNames: [String] = []
    var categoriesTotal: Int = 0
    var filePageCount: Int = 0
    var counter: Int = 0
    for (_, archivedObject) in archivedObjects {
      counter += 1
      for (_, listDocObject) in archivedObject["lstDocCategories"] {
        var categoryPageNumber = -1
        for (_, lstDocTypesObject) in listDocObject["lstDocTypes"] {
          if categoryPageNumber == -1 {
            categoryPageNumber = (lstDocTypesObject["pageNumber"].int ?? 0) - 1
          }
          if !docTypesAdded.contains(lstDocTypesObject["typeName"].stringValue) {
            var docTypeByFile = self.getDocTypeWithAssociatedPageNumber(fileCounter: counter,docType: lstDocTypesObject)
            var anotherFilePageCount: Int = 0
            if let docTypeInAnotherFile = self.getDocTypedMatchedInAnotherFile(withTypeName: lstDocTypesObject["typeName"].stringValue, tappedIndexObject: counter) {
                anotherFilePageCount = (docTypeInAnotherFile["pageCount"] as? Int ?? 0)
                docTypeByFile[(counter != 1 ? "pageNumberForFile1" : "pageNumberForFile2")] = (docTypeInAnotherFile["pageNumber"] as! Int)
            }
            let bothFilePageCount = ((lstDocTypesObject["pageCount"].int ?? 0) + anotherFilePageCount)
            categoriesTotal += bothFilePageCount
            filePageCount += bothFilePageCount
            let pageCount = bothFilePageCount == 0 ? "" : "\(bothFilePageCount)"
            docTypesAdded.append(lstDocTypesObject["typeName"].stringValue)
            data.append(TreeNode(id: "\(lstDocTypesObject["typeId"].int ?? 0)", level: 2, title: "\(lstDocTypesObject["typeName"].stringValue) (\(pageCount))", parentId: "\(listDocObject["categoryId"].int ?? 0)", data: JSON(docTypeByFile), isExpanded: false, pageCount: Int(pageCount)!))
          }
        }
        if !categoriesAdded.contains(listDocObject["categoryName"].stringValue) {
          //Set key according to file in doctypes
          let key = (counter == 1 ? "otherFilePageNumber1" : "otherFilePageNumber2")
          let docObject: [String : Any] = [key: categoryPageNumber]
            data.append(TreeNode(id: "\(listDocObject["categoryId"].int ?? 0)", level: 1, title: "\(listDocObject["categoryName"].stringValue)", parentId: "\(archivedObject["fileType"].stringValue)", data: JSON(docObject), isExpanded: false, pageCount: categoriesTotal))
              categoriesAddedAtPositions.append(data.count - 1)
              categoriesAddedNames.append(listDocObject["categoryName"].stringValue)
              categoriesTotal = 0
              categoriesAdded.append(listDocObject["categoryName"].stringValue)
            } else {
              if let index = categoriesAddedNames.index(of: listDocObject["categoryName"].stringValue) {
                let indexValue = categoriesAddedAtPositions[index.hashValue]
                data[indexValue].pageCount += categoriesTotal
                //Set key according to file in doctypes
                let key = (counter == 1 ? "otherFilePageNumber1" : "otherFilePageNumber2")
                data[ indexValue ].data?[ key ] = JSON(categoryPageNumber)
                categoriesTotal = 0
          }
        }
      }
    }
    for index in categoriesAddedAtPositions {
      data[index].title = "\(data[index].title) (\(data[index].pageCount))"
    }
    data.append(TreeNode(id: "\(archivedObjects[0]["fileType"].stringValue)", level: 0, title: "\(archivedObjects[0]["fileType"].stringValue) (\(filePageCount))", parentId: "", data: nil, isExpanded: false, pageCount: filePageCount))
      self.data = data//TreeViewLists.LoadInitialData()
      self.treeView.loadData(data: data)
  }
    
  func getDocTypeWithAssociatedPageNumber(fileCounter: Int, docType: JSON) -> [String: Any] {
    let key = (fileCounter == 1 ? "pageNumberForFile1" : "pageNumberForFile2")
    let docObject: [String : Any] = ["typeId" : docType["typeId"].int ?? 0, "typeName" : docType["typeName"].string ?? "", "pageCount" : docType["pageCount"].int ?? 0, key : (docType["pageNumber"].int ?? 0) - 1, "abbreviation" : docType["abbreviation"].string ?? "", "createdDate" : docType["createdDate"].string ?? "" ]
    return docObject
  }
}

//MARK: - Extensions
//MARK: - UITableView Datasource Methods
extension DMSPdfCompareDrawerViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.array.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.array[section]).objects.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Something"
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Something"
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: DMSOptionsInfoTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "optionsInfo") as! DMSOptionsInfoTableViewCell
    self.setDrawerIcons(forCell: cell, section: indexPath.section, row: indexPath.row)
    cell.optionKeyLabel.text = ((self.array[indexPath.section]).objects[indexPath.row]).key
    cell.optionValueLabel.text = ((self.array[indexPath.section]).objects[indexPath.row]).value
    print("Section: \(indexPath.section) CellValue: \(((self.array[indexPath.section]).objects[indexPath.row]).value)")
    if ((self.array[indexPath.section]).objects[indexPath.row]).encircled {
      cell.optionValueLabel.text = " \(((self.array[indexPath.section]).objects[indexPath.row]).value) "
      cell.optionValueLabel.layer.borderColor = UIColor(hexString: "#8ec63f")?.cgColor
      cell.optionValueLabel.layer.cornerRadius = 5
      cell.optionValueLabel.layer.borderWidth = 1
    }
    return cell
  }
}

//MARK: - UITableview Delegate Method
extension DMSPdfCompareDrawerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footer = Bundle.main.loadNibNamed("DMSPdfComparisonFooterView", owner: nil, options: nil)?[0] as! DMSOptionsFooterView
    return footer
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = Bundle.main.loadNibNamed("DMSPdfComparisonOptionsHeaderView", owner: nil, options: nil)?[0] as! DMSOptionsHeaderView
    header.headerLabel.text = self.array[section].header
    header.badgeLabel.text = ""
    if self.array[section].badgeString != "" {
      header.badgeLabel.text = "  \(self.array[section].badgeString)  "
      header.badgeLabel.layer.backgroundColor = UIColor(hexString: "#8ec63f")?.cgColor
      header.badgeLabel.layer.cornerRadius = 8
    }
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30.0
  }
}

//MARK: - Treeview Delegate Method
extension DMSPdfCompareDrawerViewController: SDTreeDelegate {
  func sdTableView(_ tableView: UITableView, selectedNode treeNode: Any, indexPath: IndexPath) {
    if let node = treeNode as? TreeNode {
      if let docTypeObject: JSON = node.data {
        let file: Int = node.pageCount
        let docObject: [String : Any] = ["typeId" : docTypeObject["typeId"].int ?? 0,"typeName" : docTypeObject["typeName"].string ?? "", "pageCount" : docTypeObject["pageCount"].int ?? 0, "pageNumberForFile1" : docTypeObject["pageNumberForFile1"].int ?? 0, "pageNumberForFile2" : docTypeObject["pageNumberForFile2"].int ?? 0, "abbreviation" : docTypeObject["abbreviation"].string ?? "", "createdDate" : docTypeObject["createdDate"].string ?? "", "otherFilePageNumber1": docTypeObject["otherFilePageNumber1"].int ?? -1, "otherFilePageNumber2": docTypeObject["otherFilePageNumber2"].int ?? -1 ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TreeViewCellSelected"), object: ["file": file, "docTypeObject": docObject])
        if let slideController = self.slideMenuController() {
          slideController.closeRight()
        }
      }
    }
  }
}

//MARK: - Sidemenu Delegate Method
extension DMSPdfCompareDrawerViewController: SlideMenuControllerDelegate {
  //MARK: - SlideViewDelegate
  func rightWillOpen() {
    self.reloadView()
    if let slideController = self.slideMenuController() {
      slideController.addRightGestures()
    }
  }
}
