//
//  UIViewController.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    func initWithStoryboardId(storyboardId:String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    static func initWithStoryboardId(storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
   //  Progress HUD
    func showProgress(status: String) {
        // Set ProgressHUD mask type
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: status)
    }
    
    func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    /// Show alert message popup with only message
    func showAlertWithTitleAndMessage(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message msg: String) {
        let alert = UIAlertController(title: Constants.alertTitle, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Show alert message popup with title and message
    func showAlert(title: String, message msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessageWithIndex(index: Int) {
        let alert = UIAlertController(title: Constants.alertTitle, message: AlertMessages.getAlertMessageAtIndex(index: index), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Set navigation item with logo image
    func setLeftNavItemWithImage() {
        let image = UIImage(named: "logo.png")
        if let img = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
    
    // Set viewcontroller background image
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    // Check whether left side menu button is available or not.
    func hasLeftMenu() -> Bool {
        if let leftItem = self.navigationController?.navigationItem.leftBarButtonItem {
            if let btnMenu = leftItem.customView as? UIButton {
                if btnMenu.tag == 1001 {
                    return true
                }
            }
        }
        return false
    }
}
