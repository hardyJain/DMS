//
//  DMSHomeTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import CloudTagView
import SlideMenuControllerSwift

class DMSHomeTableViewController: UIViewController {
  //IBOutlet
  @IBOutlet var tagView: CloudTagView!
  @IBOutlet weak var btnCompareFiles: UIButton!
  @IBOutlet weak var btnCompareHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  var btnFilter: UIButton! = nil
  //Variables
  var isMoreClicked: Bool = false
  var isCellExpanded: Bool = false
  var patientDesc = Array<DMSFilterInfo>()
  var sectionExpand = Int()
  var arrayCheckedFile: [PdfFileArchivedDetails] = [] {
    didSet {
      if self.arrayCheckedFile.count == 0 {
        self.btnCompareFiles.isHidden = true
      } else {
        self.btnCompareFiles.isHidden = false
      }
    }
  }
  
  //MARK: - View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Uncomment the following line to preserve selection between presentations
    self.initHomeView()
    self.setButtonAppearance()
    self.tableView.tableHeaderView = tagView
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if let btn = self.navigationController?.view.viewWithTag(1001) as? FilterButton {
        btn.isHidden = false
      }
    if self.arrayCheckedFile.count == 0 {
      self.btnCompareFiles.isHidden = true
    } else {
      self.btnCompareFiles.isHidden = false
    }
    //Check if performed filter
    if Globals.sharedInstance.isPerformedFilter {
      Globals.sharedInstance.isPerformedFilter = false
      self.arrayCheckedFile = []
    }
  }
    
  override func viewDidAppear(_ animated: Bool) {
    self.tableView.reloadData()
    self.initTagView()
    self.setButtonAppearance()
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Setup Home view
  func initHomeView() {
    self.title = "Home"
    NotificationCenter.default.addObserver(self, selector: #selector(DMSHomeTableViewController.internetConnectionChanged(notification:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
    self.checkInternetStatus()
    let nib = UINib(nibName: "DMSHomeTableViewSection", bundle: nil)
    self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "DMSHomeTableViewSection")
    let button1 = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(DMSHomeTableViewController.onMenuBtn(_:)))// for swift 3
    self.navigationItem.leftBarButtonItem = button1
    self.performFilterRequest(params: Globals.sharedInstance.filterInfo.getDataDictionaryForWS())
    }
    
  //MARK: - Action Methods
  //Side Menu handler.
  @IBAction func onMenuBtn(_ sender: UIBarButtonItem) {
    self.view.endEditing(true)
    if let sideController = self.slideMenuController() {
      sideController.openLeft()
    }
  }
  
  //Filter button handler
  @IBAction func onFilterBtn(_ sender: FilterButton) {
    self.performSegue(withIdentifier: Constants.SegueIdentifiers.filterViewSegue, sender: self)
  }
  
  //compare files button handler.
  @IBAction func onCompareFilesBtn(_ sender: UIButton) {
    if self.arrayCheckedFile.count > 0 {
      //Pdf can be compared now 2 files selected
      let pvc: DMSPdfAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "pdfComparisonPopupViewController") as! DMSPdfAlertViewController
      pvc.modalPresentationStyle = UIModalPresentationStyle.custom
      pvc.pdf1Name = "Patient Id: \(self.arrayCheckedFile[0].patientId)\n Reference Id: \(self.arrayCheckedFile[0].referenceId)"
      if self.arrayCheckedFile.count > 1 {
        pvc.pdf2Name = "Patient Id: \(self.arrayCheckedFile[1].patientId)\n Reference Id: \(self.arrayCheckedFile[1].referenceId)"
      }
      pvc.comparePdf = { _ in
        print("Home compare pdf tapped")
        Globals.sharedInstance.archivedData = self.arrayCheckedFile
        self.pushPdfViewController(isSinglePdf: false)
      }
      self.present(pvc, animated: false, completion: nil)
    }
  }
  
  //More button handler on cell.
  func onMoreBtn(sender: UIButton) {
    if let btnText = sender.titleLabel?.text, btnText == "More" {
      self.isMoreClicked = true
      self.sectionExpand = sender.tag
      self.tableView.reloadData()
    } else {
      self.isMoreClicked = false
      self.tableView.reloadData()
    }
  }

  //MARK: - Other Functional Methods
  //Compare Button Appearance.
  func setButtonAppearance() {
    let corners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.btnCompareFiles.layer.bounds.width, height: self.btnCompareFiles.layer.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: 12, height: 12))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.btnCompareFiles.layer.masksToBounds = true
    self.btnCompareFiles.layer.mask = mask
  }
  
  //Tag view setup.
  func initTagView() {
    self.tagView.tags.removeAll()
    self.setupTags()
    self.tagView.delegate = self
    self.tableView.tableHeaderView = tagView
    self.tableView.reloadData()
    self.headerViewSetConstraint()
  }
  
  //Tag view constraint setup.
  func headerViewSetConstraint() {
    let headerView: CloudTagView = self.tagView;
    headerView.setNeedsLayout()
    headerView.layoutIfNeeded()
    let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    var headerFrame: CGRect = headerView.frame
    headerFrame.size.height = height
    headerView.frame = headerFrame
    self.tagView = headerView
  }
  
  //Create tags for value array.
  fileprivate func setupTags() {
    if Globals.sharedInstance.arrayTagViewData.count != 0 {
      for tag in Globals.sharedInstance.arrayTagViewData {
        let tintColorTag = TagView(text: tag)
        tintColorTag.tintColor = UIColor.black
        tintColorTag.font = UIFont(name: "Arial", size: 20)!
        tintColorTag.backgroundColor = UIColor(red: 47/255, green: 187/255, blue: 180/255, alpha: 1)
        self.tagView.tags.append(tintColorTag)
      }
    }
  }
  
  //w/s request for perform filter.
  func performFilterRequest(params: Dictionary<String,AnyObject>) {
    self.showProgress(status: "Loading...")
    DMSWebRequest.POST(url: Constants.ApiUrls.filter, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams() , params: params as [String : AnyObject]?, complition: {(result) -> Void in
      print("Result - \(result)")
      self.hideProgress()
      self.arrayCheckedFile = []
      let jsonResult = JSON(result!)
      if let data = jsonResult["data"].dictionary {
        if let searchResult = data["searchResult"]?.array {
          let filterData = DMSFilterList(data: searchResult)
          Globals.sharedInstance.patientList = filterData.patientFilterList
          Globals.sharedInstance.patientFileData = filterData.patientFileData
        }
      }
      self.tableView.reloadData()
    }, failure: {(error) -> Void in
      if let err = error {
        print("Error - \(err)")
        self.hideProgress()
        self.showAlert(message: "\(err)")
      }
    })
  }
  
  //Check number of rows in section for show more button.
  //If data is more than 2 rows than show only 2 rows and show more button.
  func checkNumberOfRowsInSection(section: Int) -> Int {
    if isMoreClicked {
      let data = Globals.sharedInstance.patientFileData[section]
      if section == sectionExpand {
        return data.count
      } else if data.count > 2 {
        return 2
      } else {
        return data.count
      }
    } else {
      let data = Globals.sharedInstance.patientFileData[section]
      if data.count > 2 {
        return 2
      } else {
        return data.count
      }
    }
  }
  
  //Check internet connection.
  func internetConnectionChanged(notification: Notification) {
    self.checkInternetStatus()
  }
    
  func checkInternetStatus() {
    let status = Reach().connectionStatus()
    switch status {
    case .unknown, .offline:
      AlertMessages.showAlert(withTitle: "Alert", viewController: self, messageIndex: -1005, actionTitles: ["OK"], actions: [{(action) in }])
    case .online(.wwan):
      self.showProgress(status: "Loading")
    case .online(.wiFi):
      self.showProgress(status: "Loading")
    }
  }
  
  //Show more button and bottom line in cell.
  func checkMoreButtonAvailability(indexPath: NSIndexPath, cell:DMSHomeTableViewRowCell!) {
    if !isMoreClicked {
      let fileData = Globals.sharedInstance.patientFileData[indexPath.section]
      let count = fileData.count
      cell.btnMore.setTitle("More", for: .normal)
      if count <= 2 {
        if count == 1 {
          cell.bottomLine.isHidden = false
        } else {
          if indexPath.row == 0 {
            cell.bottomLine.isHidden = true
          } else {
            cell.bottomLine.isHidden = false
            }
          }
          cell.btnMore.isHidden = true
        } else {
          if indexPath.row == 0 {
            cell.btnMore.isHidden = true
            cell.bottomLine.isHidden = true
          } else {
            cell.btnMore.isHidden = false
            cell.bottomLine.isHidden = false
          }
        }
      } else {
        let fileData = Globals.sharedInstance.patientFileData[indexPath.section]
        let count = fileData.count
        if indexPath.section == sectionExpand {
          cell.btnMore.setTitle("Less", for: .normal)
          if indexPath.row == count-1 {
            cell?.btnMore.isHidden = false
            cell?.bottomLine.isHidden = false
          } else {
            cell?.btnMore.isHidden = true
            cell?.bottomLine.isHidden = true
          }
        } else if count <= 2 {
          if count == 1 {
            cell.bottomLine.isHidden = false
          } else {
            if indexPath.row == 0 {
              cell.bottomLine.isHidden = true
            } else {
              cell.bottomLine.isHidden = false
            }
          }
          cell?.btnMore.isHidden = true
        } else {
          cell.btnMore.setTitle("More", for: .normal)
          if indexPath.row == 1 {
            cell.bottomLine.isHidden = false
            cell.btnMore.isHidden = false
          } else {
            cell.bottomLine.isHidden = true
            cell.btnMore.isHidden = true
          }
      }
    }
  }
  
  //set row height if more button available.
  func getHeightForRow(atIndex indexPath: IndexPath) -> CGFloat {
    if !isMoreClicked {
      let fileData = Globals.sharedInstance.patientFileData[indexPath.section]
      let count = fileData.count
      if count <= 2 {
        //Nothing will happen here
      } else {
        if indexPath.row == 0 {
          return 45
        } else {
          return 80
        }
      }
    } else {
      let fileData = Globals.sharedInstance.patientFileData[indexPath.section]
      let count = fileData.count
      if indexPath.section == sectionExpand {
        if indexPath.row == count-1 {
          return 80
        } else {
          return 45
        }
      } else if count <= 2 {
        //Nothing will happen here
        } else {
        if indexPath.row == 1 {
          return 80
        } else {
          return 45
          }
        }
      }
    return 45
  }
  
  //Push to PDFView Controller.
  func pushPdfViewController(isSinglePdf: Bool) {
    guard let pdfViewController: DMSPdfComparisonViewController = self.storyboard?.instantiateViewController(withIdentifier: "pdfComparisonViewController") as? DMSPdfComparisonViewController else {
      print("Cannot load pdf view controller")
      return
    }
    pdfViewController.isSinglePdfSelected = isSinglePdf
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}

//MARK: - Extensions
// MARK: - Table view data source
extension DMSHomeTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Globals.sharedInstance.patientList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.homeTableRowCellIdentifier, for: indexPath) as? DMSHomeTableViewRowCell
        // Configure the cell...
        cell?.btnMore.tag = indexPath.section
        cell?.checkBox.isSelected = false
        var pdfFileObject = PdfFileArchivedDetails(patientId: "", patientName: "", uhid: "", location: "", fileType: "", referenceId: "", doctorName: "", admissionDate: "", dischargeDate: "")
        let data = Globals.sharedInstance.patientFileData[indexPath.section]
        let value = data[indexPath.row]
        cell?.lblDocType.text = value["fileType"] as? String
        let fileType = value["fileType"] as! String
        if fileType == "OPD" {
            cell?.lblDateTypeFirst.text = "Visit Date:"
            cell?.lblDateTypeSecond.isHidden = true
            cell?.lblDateSecond.isHidden = true
        } else {
            cell?.lblDateTypeFirst.text = "Admission Date:"
            cell?.lblDateTypeSecond.isHidden = false
            cell?.lblDateSecond.isHidden = false
        }
        let docId = value["referenceId"] as! String
        cell?.lblDocId.text = String(describing: docId)
        let admDate = value["admissionDate"] as! String?
        let date = Utility.convertDateStringToDate(date: admDate)
        cell?.lblDateFirst.text = Utility.convertDateToDateString(date: date!)
        cell?.checkBox.isSelected = value["checked"] as! Bool
        let disDate = value["dischargeDate"] as! String?
        let dateStr = Utility.convertDateStringToDate(date: disDate)
        cell?.lblDateSecond.text = Utility.convertDateToDateString(date: dateStr!)
        pdfFileObject.fileType = value["fileType"] as! String
        pdfFileObject.referenceId = "\(value["referenceId"] as! String)"
        pdfFileObject.admissionDate = value["admissionDate"] as! String
        pdfFileObject.dischargeDate = value["dischargeDate"] as! String
        self.checkMoreButtonAvailability(indexPath: indexPath as NSIndexPath, cell: cell)
        cell?.checkBox.tag = indexPath.row
        pdfFileObject.patientId = Globals.sharedInstance.patientList[indexPath.section].patientId
        pdfFileObject.patientName = Globals.sharedInstance.patientList[indexPath.section].patientName
        pdfFileObject.uhid = Globals.sharedInstance.patientList[indexPath.section].patientId
        pdfFileObject.location = Globals.sharedInstance.patientList[indexPath.section].patientAddress
        cell?.pdfArchived = pdfFileObject
        cell?.section = indexPath.section
        cell?.index = indexPath.row
        cell?.selectedRecords = { (archivedData, sender, section, index) in
        //Identify if the selected item is present in array with same patient id and if not then show alert
        if self.arrayCheckedFile.count > 0 {
          if self.arrayCheckedFile.index(where: { ($0.patientId == archivedData.patientId) }) != nil {
            } else {
              AlertMessages.showAlert(withTitle: "Alert", viewController: self, messageIndex: 4002, actionTitles: ["OK"], actions: [ { (action) in
              }])
              return
            }
          }
          if let foundAtIndex = self.arrayCheckedFile.index(where: { ($0.patientId == archivedData.patientId) && ($0.referenceId == archivedData.referenceId) }) {
            self.arrayCheckedFile.remove(at: foundAtIndex)
            Globals.sharedInstance.patientFileData[section][index]["checked"] = false as AnyObject?
            sender.isSelected = false
          } else {
            if self.arrayCheckedFile.count > 1 {
              AlertMessages.showAlert(withTitle: "Alert", viewController: self, messageIndex: 4000, actionTitles: ["OK"], actions: [ { (action) in
            } ])
            return
          }
          self.arrayCheckedFile.append(archivedData)
          sender.isSelected = true
          Globals.sharedInstance.patientFileData[section][index]["checked"] = true as AnyObject?
          if self.arrayCheckedFile.count > 0 {
            //Pdf can be compared now 2 files selected
            let pvc: DMSPdfAlertViewController = self.storyboard?.instantiateViewController(withIdentifier: "pdfComparisonPopupViewController") as! DMSPdfAlertViewController
            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.pdf1Name = "Patient Id: \(self.arrayCheckedFile[0].patientId)\n Reference Id: \(self.arrayCheckedFile[0].referenceId)"
            if self.arrayCheckedFile.count > 1 {
              pvc.pdf2Name = "Patient Id: \(self.arrayCheckedFile[1].patientId)\n Reference Id: \(self.arrayCheckedFile[1].referenceId)"
            }
            pvc.comparePdf = { _ in
            Globals.sharedInstance.archivedData = self.arrayCheckedFile
            self.pushPdfViewController(isSinglePdf: false)
            }
            self.present(pvc, animated: false, completion: nil)
          }
        }
      }
      cell?.btnMore.addTarget(self, action: #selector(onMoreBtn(sender:)), for: .touchUpInside)
      return cell!
  }
}

//MARK: - UITableView Delegate Methods
extension DMSHomeTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableView.cellForRow(at: indexPath) as! DMSHomeTableViewRowCell
    Globals.sharedInstance.archivedData = [cell.pdfArchived!]
    self.tableView.reloadData()
    self.pushPdfViewController(isSinglePdf: true)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.getHeightForRow(atIndex: indexPath)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DMSHomeTableViewSection")
    let header = cell as! DMSHomeSectionView
    header.filterInfo = Globals.sharedInstance.patientList[section]
    return cell
  }
}

//MARK: - Tagview Delegate
extension DMSHomeTableViewController : TagViewDelegate {
  func tagDismissed(_ tag: TagView) {
    Globals.sharedInstance.arrayTagViewData.removeObject(object: tag.text)
    if let range = tag.text.range(of: ":") {
      let filterText = tag.text.substring(from: range.upperBound).trimmingCharacters(in: .whitespacesAndNewlines)
      for (key, value) in Globals.sharedInstance.dictTagView {
        if key == Globals.sharedInstance.filterInfo.filterDocTypeIdKey {
        }
        if value as? String == filterText {
          Globals.sharedInstance.dictTagView.updateValue("" as AnyObject, forKey: key)
        }
        if key == Globals.sharedInstance.filterInfo.filterDocTypeIdKey {
          var upatedArray = NSMutableArray()
          for (name, id) in TreeViewLists.allTreeNodeId {
            if name == filterText {
              upatedArray = value as! NSMutableArray
              upatedArray.remove(id)
            }
          }
          Globals.sharedInstance.dictTagView.updateValue(upatedArray as AnyObject, forKey: key)
        }
      }
    }
    self.performFilterRequest(params:Globals.sharedInstance.dictTagView)
    self.headerViewSetConstraint()
  }
}
