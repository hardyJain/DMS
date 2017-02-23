//
//  DMSHomeTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import REFrostedViewController

class DMSHomeTableViewController: UITableViewController {

    var btnFilter: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.initHomeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHomeView() {
        let nib = UINib(nibName: "DMSHomeTableViewSection", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "DMSHomeTableViewSection")
        btnFilter = UIButton(type: .custom)
        btnFilter.frame = CGRect(x: self.view.frame.size.width - 100, y: self.view.frame.size.height - 100, width: 60, height: 60)
        btnFilter.setTitle("F", for: .normal)
        btnFilter.layer.cornerRadius = btnFilter.frame.size.width/2
        btnFilter.backgroundColor = UIColor.red
        btnFilter.layer.shadowRadius = 4
        btnFilter.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.view.addSubview(btnFilter)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    @IBAction func onMenuBtn(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        
        self.frostedViewController.presentMenuViewController()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.homeTableRowCellIdentifier, for: indexPath) as? DMSHomeTableViewRowCell

        // Configure the cell...
        cell?.lblDocType.text = "OPD"
        if indexPath.row == 1 {
            cell?.btnMore.isHidden = false
            cell?.bottomLine.isHidden = false
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DMSHomeTableViewSection")
        let header = cell as! DMSHomeSectionView
        header.lblUHIDNo.text = "123h23"
        header.lblPatientName.text = "Hardik"
        return cell
    }
}

