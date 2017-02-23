//
//  DMSLoginTableViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DMSLoginTableViewController: UITableViewController {
    
    //IBOutlet
    var txtEmail: SkyFloatingLabelTextField!
    var txtPassword: SkyFloatingLabelTextField!
    var currentTextField: SkyFloatingLabelTextField!
    var toolBar = HSToolBar(doneOnly: false)
    
    //Variables

    //MARK: - UIVIew Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
            self.initLoginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Init Login View
    func initLoginView() {
        toolBar.toolBarDelegate = self
    }
    
    //MARK: - IBAction Methods
    @IBAction func onLoginBtn(_ sender: UIButton) {
        if isValidate() {
            self.performSegue(withIdentifier: Constants.SegueIdentifiers.loginToHomeSegue, sender: self)
        }
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
}

//MARK: - Extensions 
//Toolbar delegate methods
extension DMSLoginTableViewController: HSToolbarDelegate {
    func onMovePrevious(sender: UIButton) {
        if txtPassword!.isEditing {
            txtEmail!.becomeFirstResponder()
        }
    }
    
    func onMoveNext(sender: UIButton) {
        if txtEmail!.isEditing {
            txtPassword!.becomeFirstResponder()
        }
    }
    
    func onToolbarDone(sender: UIButton) {
        currentTextField!.resignFirstResponder()
    }
}

//UITableViewController Datasource Methods
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
        // Configure the cell...
        switch indexPath.row {
        case 0:
            self.txtEmail = cell?.txtContent
            self.txtEmail.delegate = self
            self.txtEmail.placeholder = "Email id"
            self.txtEmail.text = "hardik.jain@gmail.com"
            break
        case 1:
            self.txtPassword = cell?.txtContent
            self.txtPassword.delegate = self
            self.txtPassword.isSecureTextEntry = true
            self.txtPassword.placeholder = "Password"
            self.txtPassword.text = "Hardik"
            break
        default:
            break
        }
        return cell!
    }
}

//UITableViewContrroller Delegate Methods
extension DMSLoginTableViewController {
    
}

//UITextField Delegate Methods
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
}
