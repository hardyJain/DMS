//
//  DMSSplashScreenController.swift
//  DMS
//
//  Created by Swapnil Dhotre on 24/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import Alamofire

class DMSSplashScreenController: UIViewController {
  //IBOutlet
  //Variables
  
  //MARK: - View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = "Entered url is not correct"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    self.initAlertForBaseUrl(withUrl: "", msg: "Enter api url")
  }
  //MARK: - Other Functional Methods.
  //Alertview for check base url on splash screen.
  func initAlertForBaseUrl(withUrl url: String, msg: String) {
    if let baseUrl = UserDefaults.standard.value(forKey: "baseUrl") as? String {
      self.showProgress(status: "Checking...")
      self.checkValidation(withIP: baseUrl)
    } else {
      let alert: UIAlertController = UIAlertController(title: "Configuration", message: "\(msg)\neg: 192.168.0.25:81", preferredStyle: .alert)
      alert.addTextField { (textField) in
      textField.placeholder = "Enter base ip"
      textField.text = url
      textField.keyboardType = .numberPad
    }
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        if let enteredUrl = alert.textFields?[0].text {
          if self.isValidIP(ipString: enteredUrl) {
            UserDefaults.standard.setValue(enteredUrl, forKey: "baseUrl")
            self.showProgress(status: "Checking...")
            self.checkValidation(withIP: enteredUrl)
          } else {
            self.initAlertForBaseUrl(withUrl: enteredUrl, msg: "Entered ip is not valid")
          }
        }
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }
  //Check validation for ip is valid or not.
  func isValidIP(ipString: String) -> Bool {
    let separatedByColon = ipString.components(separatedBy: ":")
    if separatedByColon.count == 2 && separatedByColon[1] != "" {
      let parts = separatedByColon[0].components(separatedBy: ".")
      let nums = parts.flatMap { Int($0) }
      return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    return false
  }
  //W/S request for check base url is correct or not.
  func checkValidation(withIP ip: String) {
    Alamofire.request("http://\(ip)/api/Connectioncheck").responseJSON { (response) in
      print(response.request!)  // original URL request
      print(response.response!) // HTTP URL response
      print(response.data!)     // server data
      print(response.result)   // result of response serialization
      self.hideProgress()
      if response.result.isFailure {
        UserDefaults.standard.setValue(nil,forKey: "baseUrl")
        self.initAlertForBaseUrl(withUrl: ip, msg: "Entered ip is not valid")
      } else {
        Constants.ApiUrls.baseUrl = "http://\(ip)/"
        self.checkIfUserHasLoggedIn()
        if let JSON = response.result.value {
          print("JSON: \(JSON)")
        }
      }
    }
  }
  //Check user is already logged in or not.
  func checkIfUserHasLoggedIn() {
    if let userLoggedIn = Utility.getUserLocalObjectForKey(key: Constants.UserDefault.userLoggedToken) as? String, userLoggedIn == "UserLoggedIn" {
      (UIApplication.shared.delegate as! AppDelegate).initDrawerView()
    } else {
      (UIApplication.shared.delegate as! AppDelegate).initLoginScreen()
    }
  }
}
