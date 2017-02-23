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
    //IBOutlet
    var btnFilter: UIButton! = nil
    
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
    }
    
    //MARK: - IBAction Methods
    @IBAction func onMenuBtn(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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

    //MARK: - UITableView Delegate Methods
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
    
    //MARK: - Other Functional Methods
    func onFilterBtn() {
        self.performSegue(withIdentifier: Constants.SegueIdentifiers.filterViewSegue, sender: self)
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

