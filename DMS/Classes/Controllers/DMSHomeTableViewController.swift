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

class DMSHomeTableViewController: UITableViewController {
    //IBOutlet
    var btnFilter: UIButton! = nil
    var arrayContent: NSMutableArray = ["OPD","IPD","IPD","OPD","IPD","IPD","OPD","IPD","IPD","OPD"]
    var isMoreClicked: Bool = false
    var isCellExpanded: Bool = false
    
    var filterInfo: DMSFilterInfo = DMSFilterInfo()
    var patientList = Array<DMSFilterInfo>()
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
    
    func onMoreBtn(sender: UIButton) {
        if isCellExpanded {
            isMoreClicked = false
        } else {
            isMoreClicked = true
            tableView.beginUpdates()
            let index = IndexPath(row: 2, section: sender.tag)
            let newObject = "Har"
                arrayContent.insert(newObject, at: 7)
            tableView.insertRows(at: [index], with: UITableViewRowAnimation.automatic)
            tableView.endUpdates()
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
}

//Extensions
extension DMSHomeTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return patientList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if isMoreClicked {
                return self.arrayContent.count
            } else {
                return 2
            }
        } else {
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.homeTableRowCellIdentifier, for: indexPath) as? DMSHomeTableViewRowCell
        
        // Configure the cell...
        cell?.lblDocType.text = arrayContent[indexPath.row] as? String
        cell?.btnMore.tag = indexPath.section
        if isMoreClicked {
            if indexPath.row == arrayContent.count - 1 {
                cell?.btnMore.isHidden = false
                cell?.bottomLine.isHidden = false
            }
        } else {
            if indexPath.row == 1 {
                cell?.btnMore.isHidden = false
                cell?.bottomLine.isHidden = false
            }
        }
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
        print("PAtient list in section - \(patientList[section])")
        header.filterInfo = patientList[section]
        return cell
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

