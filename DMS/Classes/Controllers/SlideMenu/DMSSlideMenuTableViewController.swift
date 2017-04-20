//
//  DMSSlideMenuTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class DMSSlideMenuTableViewController: UITableViewController {
  @IBOutlet weak var userIcon: UIImageView!
  @IBOutlet weak var labelUserName: UILabel!
  @IBOutlet weak var labelGender: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.tableView.tableFooterView = UIView()
    self.labelUserName.text = "Admin"
    if let gender = Utility.getUserLocalObjectForKey(key: Constants.UserDefault.gender) as? String {
      if gender == "M" {
        self.labelGender.text = "Male"
        self.userIcon.image = UIImage(named: "Male")
      } else {
        self.labelGender.text = "Female"
        self.userIcon.image = UIImage(named: "Female")
      }
    }
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
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.slideMenuCellIdentifier, for: indexPath) as? DMSSlideMenuTableViewCell
    // Configure the cell...
    if indexPath.row == 0 {
      cell?.txtLabel.text = "Home"
      cell?.lblIcon.text = "S"
    } else {
      cell?.txtLabel.text = "Logout"
      cell?.lblIcon.text = "l"
    }
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0:
      self.setNavigationController(withIdentifier: Menus.homeController)
      break
    case 1:
      _ = Utility.setUserLocalObject(object: nil, key: Constants.UserDefault.userLoggedToken)
      (UIApplication.shared.delegate as! AppDelegate).initLoginScreen()
      break
    default:
      break
    }
  }
  
  func setNavigationController(withIdentifier identifier: Menus) {
    let centerViewController: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: identifier.rawValue)
    let centerNavigationController: UINavigationController = UINavigationController(rootViewController: centerViewController!)
    if let slideController = self.slideMenuController() {
      slideController.mainViewController = centerNavigationController
      slideController.closeLeft()
    }
  }
}
