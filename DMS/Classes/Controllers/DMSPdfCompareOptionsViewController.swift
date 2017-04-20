//
//  DMSPdfCompareOptionsViewController.swift
//  DMS
//
//  Created by Swapnil Dhotre on 14/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import RATreeView
import SwiftyJSON
import Alamofire

class DMSPdfCompareOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var treeView: RATreeView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var pdfArchivedRecords: [PdfFileArchivedDetails] = []
    
    struct CellRecords {
    
        var icon: String
        var key: String
        var value: String
        var encircled: Bool
    }
    
    struct Sections {
    
        var header: String
        var badgeString: String
        var objects: [CellRecords]
    }
    
    var patientInfo: [CellRecords] = []
    var fileOne: [CellRecords] = []
    var fileTwo: [CellRecords] = []
    
    var array: [Sections] = []
    
    var docTypes: [Parameters] = []
    var treeData: [DataObjects] = [DataObjects]()
    var filteresTreeData: [DataObjects] = [DataObjects]()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MRAK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.reloadView()
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.array[section]).objects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        if tableView == self.treeView {
//        
//            return ""
//        }
        return "Something"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        if tableView == self.treeView {
//        
//            return nil
//        }
        
        let header = Bundle.main.loadNibNamed("PdfComparisonOptionsHeaderView", owner: nil, options: nil)?[0] as! OptionsHeaderView
        
        header.headerLabel.text = self.array[section].header
        header.badgeLabel.text = ""
        
        if self.array[section].badgeString != "" {
        
            header.badgeLabel.text = "  \(self.array[section].badgeString)  "
            header.badgeLabel.layer.backgroundColor = UIColor(hexString: "#8ec63f")?.cgColor
            header.badgeLabel.layer.cornerRadius = 8
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: OptionsInfoTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "optionsInfo") as! OptionsInfoTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
//        if tableView == self.treeView {
//            
//            return ""
//        }
        return "Something"
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
//        if tableView == self.treeView {
//            
//            return nil
//        }
        let footer = Bundle.main.loadNibNamed("PdfComparisonFooterView", owner: nil, options: nil)?[0] as! OptionsFooterView
        
        return footer
        
    }
    
    //MARK: - Action Methods
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        Utility.sharedInstance.isPdfScrollable = sender.isOn
    }
    
    //MARK: - Custom Methods
    func reloadView() {
    
        self.initCellData()
        self.setTableViewProperties()
        self.registerNibFiles()
    }
    
    func registerNibFiles() {
    
        let headerNib = UINib(nibName: "PdfComparisonOptionsHeaderView", bundle: nil)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: Constants.Nib.optionsHeaderIdentifier)
        
        let footerNib = UINib(nibName: "PdfComparisonFooterView", bundle: nil)
        self.tableView.register(footerNib, forCellReuseIdentifier: Constants.Nib.optionsFooterIdentifier)
    }
    
    func initCellData() {
    
        self.pdfArchivedRecords = Utility.sharedInstance.archivedData
        self.getArchivedDataFromApi()

        if self.pdfArchivedRecords.count > 0 {
            
            self.patientInfo = []
            self.patientInfo.append( CellRecords(icon: "", key: "", value: self.pdfArchivedRecords[0].patientName, encircled: false) )
            self.patientInfo.append( CellRecords(icon: "", key: "UHID", value: self.pdfArchivedRecords[0].patientId, encircled: true) )
            self.patientInfo.append( CellRecords(icon: "", key: "", value: self.pdfArchivedRecords[0].location, encircled: false) )
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
        self.array.append(Sections(header: "File-One", badgeString: "IPD", objects: fileOne))
        
        //This condition is checked for Second file if only single file is selected
        if fileTwo.count > 0 {
        
            self.array.append(Sections(header: "File-Two", badgeString: "IPD", objects: fileTwo))
        }
        
        self.tableView.reloadData()
    }
    
    func setTableViewProperties() {
    
        self.treeView.delegate = self
        self.treeView.dataSource = self
        self.treeView.register(UINib(nibName: String("DMSFilterExpandTableViewCell"), bundle: nil), forCellReuseIdentifier: String(Constants.TableViewCellIdentifiers.filterExpandTableCellIdentifier))
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        if self.fileTwo.count > 0 {
        
            self.tableViewHeightConstraint.constant = 500
        } else {
        
            self.tableViewHeightConstraint.constant = 300
        }
    }
    
    func getDataDictionaryForArchived(archivedObject: PdfFileArchivedDetails) -> Parameters {
        
        let param: Parameters = [
            
            "lstSearchParam":[
                [
                    "patientId": archivedObject.patientId,
                    "fileType": archivedObject.fileType,
                    "fileTypeRefId": archivedObject.referenceId
                ]
            ]
        ]
        
        return param
    }
    
    func getArchivedDataFromApi() {
        
        self.showProgress(status: "Loading...")
        
        var params: Parameters = [:]
        if self.pdfArchivedRecords.count > 0 {
        
            params = self.getDataDictionaryForArchived(archivedObject: self.pdfArchivedRecords[0])
        }
        
        DMSWebRequest.POST(url: Constants.ApiUrls.archived, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: params as [String : AnyObject]?, complition: {(result) -> Void in
            print("Result - \(result)")
            self.hideProgress()
            
            if let data = result {
                
                let json = JSON(data)
                
                var pageCount: Int = 0
                
                var docTypes: [Parameters] = []
                for (_, object) in json["data"]["archiveData"][0]["lstDocCategories"][0]["lstDocTypes"] {
                    
                    pageCount += object["pageCount"].int ?? 0
                    
                    let object: Parameters = [
                        
                        "typeId": object["typeId"].int ?? 0,
                        "typeName": object["typeName"].string ?? "",
                        "abbreviation": object["abbreviation"].string ?? "",
                        "createdDate": object["createdDate"].string ?? "",
                        "pageCount": object["pageCount"].int ?? 0,
                        "pageNumber": object["pageNumber"].int ?? 0
                        
                    ]
                    
                    docTypes.append(object)
                }
                
                self.docTypes = docTypes
                
                let listDocCategory = json["data"]["archiveData"][0]["lstDocCategories"][0]
                
                self.treeData = DataObjects.compareTreeRootChildren(data: listDocCategory)
                self.treeView.reloadData()
                
                //self.getPdfFile(docTypes: docTypes, pageCount: pageCount)
                
            }
            
            }, failure: {(error) -> Void in
                if let err = error {
                    print("Error - \(err)")
                    self.hideProgress()
                    self.showAlert(message: "\(err)")
                }
        })
        
    }
    
}

extension DMSPdfCompareOptionsViewController: RATreeViewDataSource {
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? DataObjects {
            return item.children.count
        } else {
            return self.treeData.count
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        
        guard let cell = treeView.dequeueReusableCell(withIdentifier: String(Constants.TableViewCellIdentifiers.filterExpandTableCellIdentifier)) as? DMSFilterExpandTableViewCell,
            let item = item as? DataObjects else {
                fatalError()
        }
        
        let level = treeView.levelForCell(forItem: item as Any)
//        cell.setup(withTitle: item.name, level: level)
        
//        cell.checkBoxbtn.addTarget(self, action: #selector(onCheckBoxBtn(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return treeData[index]
        } else if let item = item as? DataObjects {
            return item.children[index]
        } else {
            fatalError()
        }
    }
}

extension DMSPdfCompareOptionsViewController: RATreeViewDelegate {

    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        
        if let object: DataObjects = item as? DataObjects {
        
            print("object: \(object)")
        }
    }
    
}
