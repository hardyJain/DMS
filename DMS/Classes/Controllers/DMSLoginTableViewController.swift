//
//  DMSLoginTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class DMSLoginTableViewController: UITableViewController {
    //IBOutlet
  var txtEmail: SkyFloatingLabelTextField!
  var txtPassword: SkyFloatingLabelTextField!
  var currentTextField: SkyFloatingLabelTextField!
  var toolBar = HSToolBar(doneOnly: false)
  //Variables
  var loginInfo: DMSLoginInfo?

  //MARK: - UIVIew Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Uncomment the following line to preserve selection between presentations
    self.initLoginView()
    loginInfo = DMSLoginInfo.init()
    self.hideProgress()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
  }
    
  //Setup Login View
  func initLoginView() {
    toolBar.toolBarDelegate = self
  }
    
  //MARK: - IBAction Methods
  @IBAction func onLoginBtn(_ sender: UIButton) {
    loginInfo?.email = self.txtEmail.text!
    loginInfo?.password = self.txtPassword.text!
    self.perforLogin()
  }
    
  //MARK: - Other Functional Methods
  // Check validation.
  func isValidate() -> Bool {
    /**** Clear white space to all textfield. ****/
    txtEmail.text = txtEmail.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
    txtPassword.text = txtPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
    // Check all textfield are empty or not. If empty then return false otherwise continue.
    if txtEmail!.text!.isEmpty && txtPassword!.text!.isEmpty {
      self.showAlert(message: AlertMessages.getAlertMessageAtIndex(index: 1))
      return false
    }
    /* Check one by one textfield validation */
    if txtEmail!.text!.isEmpty {
      self.showAlert(message: AlertMessages.getAlertMessageAtIndex(index: 21))
      return false
    } else if !Utility.sharedInstance.isValidEmail(email: (txtEmail?.text)!) {
      self.showAlert(message: AlertMessages.getAlertMessageAtIndex(index: 22))
      return false
    } else if txtPassword!.text!.isEmpty {
      self.showAlert(message: AlertMessages.getAlertMessageAtIndex(index: 23))
      return false
    }
      return true
    }
    
  func perforLogin() {
    self.showProgress(status: "Loading...")
    let paramString = DMSLoginInfo.getDataStringForEncodedRequest(loginInfo!)
    DMSWebRequest.POSTSTRING(requestString: paramString(),complition: {(result) -> Void in
      if let responseResult = result {
        print("Response Result: \(responseResult)")
        let jsonResult = JSON(responseResult)
        if jsonResult["error"].stringValue == "invalid_grant" {
          DispatchQueue.main.async {
          AlertMessages.showAlert(withTitle: "Alert", viewController: self, messageIndex: 4003, actionTitles: ["OK"], actions: [{(action) in }])
          }
        } else {
          _ = Utility.setUserLocalObject(object: "UserLoggedIn" as AnyObject?, key: Constants.UserDefault.userLoggedToken)
          if let accessToken = jsonResult["access_token"].string {
            if Utility.setUserLocalObject(object: accessToken as AnyObject?, key: Constants.UserDefault.authAccessToken) { }
          }
          if let refereshToken = jsonResult["refresh_token"].string {
            if Utility.setUserLocalObject(object: refereshToken as AnyObject?, key: Constants.UserDefault.authRefereshToken) { }
          }
          if let gender = jsonResult["userGender"].string {
            _ = Utility.setUserLocalObject(object: gender as AnyObject, key: Constants.UserDefault.gender)
          }
          DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).initDrawerView()
            // Go to home screen from here
          }
        }
      }
      self.hideProgress()
    }, failure: {(error) -> Void in
      if let err = error {
        self.hideProgress()
        self.showAlert(message: "\(err)")
      }
    })
  }
}

//MARK: - Extensions
//MARK: - Toolbar delegate methods
extension DMSLoginTableViewController: HSToolbarDelegate {
  //Toolbar previous button handler.
  func onMovePrevious(sender: UIButton) {
    if txtPassword!.isEditing {
      txtEmail!.becomeFirstResponder()
    }
  }
  //Toolbar next button handler.
  func onMoveNext(sender: UIButton) {
    if txtEmail!.isEditing {
      txtPassword!.becomeFirstResponder()
    }
  }
  //Toolbar done button handler.
  func onToolbarDone(sender: UIButton) {
    currentTextField!.resignFirstResponder()
  }
}

//MARK: - UITableViewController Datasource Methods
extension DMSLoginTableViewController {
    // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
    
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.loginTableCellIdentifier, for: indexPath) as? LoginTableViewCell
    switch indexPath.row {
    case 0:
      self.txtEmail = cell?.txtContent
      self.txtEmail.delegate = self
      self.txtEmail.tag = Tag.Login.email
      self.txtEmail.placeholder = "Email id"
      self.txtEmail.text = "ADMIN"
      break
    case 1:
      self.txtPassword = cell?.txtContent
      self.txtPassword.delegate = self
      self.txtPassword.tag = Tag.Login.password
      self.txtPassword.isSecureTextEntry = true
      self.txtPassword.placeholder = "Password"
      self.txtPassword.text = "admin"
      break
    default:
      break
    }
    return cell!
  }
}

//MARK: - UITextField Delegate Methods
extension DMSLoginTableViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    currentTextField = textField as? SkyFloatingLabelTextField
    textField.inputAccessoryView = toolBar
    if textField.tag == Tag.Login.email {
      toolBar.btnNext.isEnabled = true
      toolBar.btnPrevious.isEnabled = false
    } else if textField.tag == Tag.Login.password {
      toolBar.btnNext.isEnabled = false
      toolBar.btnPrevious.isEnabled = true
    } else {
      toolBar.btnNext.isEnabled = true
      toolBar.btnPrevious.isEnabled = true
    }
  }
    
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.tag == Tag.Login.email {
      loginInfo?.email = self.txtEmail.text!
    } else if textField.tag == Tag.Login.password {
      loginInfo?.password = self.txtPassword.text!
    }
  }
}
