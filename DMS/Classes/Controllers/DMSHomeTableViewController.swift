//
//  DMSHomeTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import REFrostedViewController
import SwiftyJSON
import CloudTagView

class DMSHomeTableViewController: UITableViewController {
    //IBOutlet
   
    @IBOutlet var tagView: CloudTagView!
    
    var btnFilter: UIButton! = nil
//    var arrayContent: NSMutableArray = ["OPD","IPD","IPD","OPD","IPD","IPD","OPD","IPD","IPD","OPD"]
    var isMoreClicked: Bool = false
    var isCellExpanded: Bool = false
    
    var filterInfo: DMSFilterInfo = DMSFilterInfo()
    var patientList = Array<DMSFilterInfo>()
    var patientDesc = Array<DMSFilterInfo>()
    
    var sectionExpand = Int()
    var patientFileData = [AnyObject]()
    var arrayCheckedFile: NSMutableArray = NSMutableArray()
    //Variables
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.initHomeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Init Home view
    func initHomeView() {
        let nib = UINib(nibName: "DMSHomeTableViewSection", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "DMSHomeTableViewSection")
        btnFilter = FilterButton(type: .system) //UIButton(type: .custom)
        btnFilter.frame = CGRect(x: self.view.frame.size.width - 120, y: self.view.frame.size.height - 120, width: 80, height: 80)
        btnFilter.titleLabel?.font = UIFont(name: "DMSFont", size: 30)
        btnFilter.setTitle("f", for: .normal)
        btnFilter.setTitleColor(UIColor.white, for: .normal)
        btnFilter.addTarget(self, action: #selector(onFilterBtn), for: .touchUpInside)
        self.navigationController?.view.addSubview(btnFilter)
        self.initTagView()
        self.performFilterRequest()
    }
    
    //MARK: - IBAction Methods
    @IBAction func onMenuBtn(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
    //MARK: - Other Functional Methods
    func onFilterBtn() {
        self.performSegue(withIdentifier: Constants.SegueIdentifiers.filterViewSegue, sender: self)
    }
    
    func initTagView() {
        self.tagView.delegate = self
        self.setupTags()
    }
    
    fileprivate func setupTags() {
        let tags = ["This", "is", "a", "example", "of", "Cloud", "Tag", "View","Hardik","Jain","Scorg","Technologies"]
        
        for tag in tags {
            let tintColorTag = TagView(text: tag)
            tintColorTag.tintColor = UIColor.black
            tintColorTag.font = UIFont(name: "Arial", size: 20)!
            tintColorTag.backgroundColor = UIColor(red: 47/255, green: 187/255, blue: 180/255, alpha: 1)
            self.tagView.tags.append(tintColorTag)
        }
    }
    
    func onMoreBtn(sender: UIButton) {
        print("Button Tag - \(sender.tag)")
        if isMoreClicked {
            self.isMoreClicked = false
            self.tableView.reloadData()
        } else {
            self.sectionExpand = sender.tag
            self.isMoreClicked = true
            self.tableView.reloadData()
        }
    }
    
    func performFilterRequest() {
        self.showProgress(status: "Loading...")
        let params = DMSFilterInfo.getDataDictionaryForWS(filterInfo)
        
        DMSWebRequest.POST(url: Constants.ApiUrls.filter, authType: .Bearer, requestFormat: .JsonFormat, headers: ["Device-Id": Constants.deviceId, "OS": "iOS", "OS-Version": Constants.OSVersion], params: params() as [String : AnyObject]?, complition: {(result) -> Void in
            print("Result - \(result)")
                self.hideProgress()
                let jsonResult = JSON(result!)
                if let data = jsonResult["data"].dictionary {
                    if let searchRes = data["searchResult"]?.array {
                        let filterData = DMSFilterList(data: searchRes)
                        self.patientList = filterData.patientFilterList
                        self.patientFileData = filterData.patientFileData
                    }
                }
            self.tableView.reloadData()
            }, failure: {(error) -> Void in
                if let err = error {
                    print("Error - \(err)")
                    self.hideProgress()
                }
            })
        }
    
    func onCheckBoxBtn(sender: UIButton!) {
        let value = sender.tag;
        if arrayCheckedFile.contains(value) {
            arrayCheckedFile.remove(value)
            sender.isSelected = false
        } else {
            arrayCheckedFile.add(value)
            sender.isSelected = true
        }
        print("Selecetd Array \(arrayCheckedFile)")
    }
    
    func checkNumberOfRowsInSection(section: Int) -> Int {
        if isMoreClicked {
            let data = patientFileData[section]
            if let rowValue = data as? NSArray {
                if section == sectionExpand {
                    return rowValue.count
                } else if rowValue.count > 2 {
                    return 2
                } else {
                    return rowValue.count
                }
            } else {
                return 0
            }
        } else {
            let data = patientFileData[section]
            if let rowValue = data as? NSArray {
                if rowValue.count > 2 {
                    return 2
                } else {
                    return rowValue.count
                }
            } else {
                return 0
            }
        }
    }
    
    func checkMoreButtonAvailability(indexPath: NSIndexPath, cell:DMSHomeTableViewRowCell!) {
        if !isMoreClicked {
            let fileData = patientFileData[indexPath.section]
            if let rowValue = fileData as? NSArray {
                let count = rowValue.count
                if count >= 2 {
                    if indexPath.row == 1 {
                        cell?.btnMore.isHidden = false
                        cell?.bottomLine.isHidden = false
                    } else {
                        cell?.btnMore.isHidden = true
                        cell?.bottomLine.isHidden = true
                    }
                } else {
                    cell?.btnMore.isHidden = false
                    cell?.bottomLine.isHidden = false
                }
            }
        } else {
            let fileData = patientFileData[indexPath.section]
            if let rowValue = fileData as? NSArray {
                let count = rowValue.count
                if indexPath.section == sectionExpand {
                    if indexPath.row == count-1 {
                        cell?.btnMore.isHidden = false
                        cell?.bottomLine.isHidden = false
                    } else {
                        cell?.btnMore.isHidden = true
                        cell?.bottomLine.isHidden = true
                    }
                } else if count >= 2 {
                    if indexPath.row == 1 {
                        cell?.btnMore.isHidden = false
                        cell?.bottomLine.isHidden = false
                    } else {
                        cell?.btnMore.isHidden = true
                        cell?.bottomLine.isHidden = true
                    }
                } else {
                    cell?.btnMore.isHidden = false
                    cell?.bottomLine.isHidden = false
                }
            }
        }
    }
}

//Extensions
extension DMSHomeTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return patientList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkNumberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.homeTableRowCellIdentifier, for: indexPath) as? DMSHomeTableViewRowCell
        
        // Configure the cell...
        cell?.btnMore.tag = indexPath.section
        
        let data = patientFileData[indexPath.section]
        if let rowValue = data as? NSArray {
            let value = rowValue[indexPath.row]
            if let s = value as? NSDictionary {
                cell?.lblDocType.text = s.object(forKey: "fileType") as! String?
                
                let docId = s.object(forKey: "referenceId") as! NSNumber
                cell?.lblDocId.text = String(describing: docId)
                let admDate = s.object(forKey: "admissionDate") as! String?
                let date = Utility.convertDateStringToDate(date: admDate)
                cell?.lblDateFirst.text = Utility.convertDateToDateString(date: date!)
                
                let disDate = s.object(forKey: "dischargeDate") as! String?
                let dateStr = Utility.convertDateStringToDate(date: disDate)
                cell?.lblDateSecond.text = Utility.convertDateToDateString(date: dateStr!)
            }
        }
        self.checkMoreButtonAvailability(indexPath: indexPath as NSIndexPath, cell: cell)
        cell?.checkBox.tag = indexPath.row
        cell?.checkBox.addTarget(self, action: #selector(onCheckBoxBtn(sender:)), for: .touchUpInside)
        cell?.btnMore.addTarget(self, action: #selector(onMoreBtn(sender:)), for: .touchUpInside)
        return cell!
    }
    
    //MARK: - UITableView Delegate Methods
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DMSHomeTableViewSection")
        let header = cell as! DMSHomeSectionView
        header.filterInfo = patientList[section]
        return cell
    }
}

extension DMSHomeTableViewController : TagViewDelegate {
    func tagDismissed(_ tag: TagView) {
        print("tag dismissed: " + tag.text)
    }
    
    func tagTouched(_ tag: TagView) {
        print("tag touched: " + tag.text)
    }
}

//Custom Button Class
class FilterButton: UIButton {
    var shadowLayer: CAShapeLayer!
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.size.width/2).cgPath
            shadowLayer.fillColor = UIColor(red: 236/255, green: 63/255, blue: 48/255, alpha: 1).cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }        
    }
}

