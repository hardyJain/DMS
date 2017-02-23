//
//  DMSSlideMenuTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSSlideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.slideMenuCellIdentifier, for: indexPath) as? DMSSlideMenuTableViewCell
       
        // Configure the cell...
        
        cell?.txtLabel.text = "Home"

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let navigationController: DMSMenuNavigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "contentController") as! DMSMenuNavigationViewController
        switch indexPath.row {
        case 0:
            let homeVC: DMSHomeTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeController") as! DMSHomeTableViewController
            navigationController.viewControllers = [homeVC]
            break
        default:
            break
        }
    }
}
