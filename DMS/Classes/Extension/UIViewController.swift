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
    
//    func pushScreenWithId(screenId: Int) {
//        let mainView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController: UIViewController = mainView.instantiateViewControllerWithIdentifier(VSPageInfo.pageNameForId(screenId))
//        
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
    
//    func presentScreenWithId(screenId: Int) {
//        let mainView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController: UIViewController = mainView.instantiateViewControllerWithIdentifier(VSPageInfo.pageNameForId(screenId))
//        
//        self.navigationController?.present(UINavigationController.init(rootViewController: viewController), animated: true, completion: nil)
//    }
    
//    func presentScreenWithId(screenId: Int,withNavigationColor navigationBarColor: UIColor) {
//        let mainView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController: UIViewController = mainView.instantiateViewControllerWithIdentifier(VSPageInfo.pageNameForId(screenId))
//        
//        let nav = UINavigationController(rootViewController: viewController)
//        nav.navigationBar.barTintColor = navigationBarColor
//        nav.navigationBar.translucent = false
//        self.presentViewController(nav, animated: true, completion: nil)
//    }
    
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
    
//    func showSignInAlert() {
//        let alert = UIAlertController(title: title, message: AlertMessages.getAlertMessageAtIndex(index: 0), preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        let loginAction = UIAlertAction(title: "Sign In", style: .default) { (action) in
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let loginController = sb.instantiateViewControllerWithIdentifier("sign") as! VSLoginView
//            loginController.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
//            let loginNav = UINavigationController(rootViewController: loginController)
//            loginNav.navigationBar.barTintColor = UIColor.blackColor()
//            loginNav.navigationBar.translucent = false
//            self.frostedViewController.hideMenuViewController()
//            self.presentViewController(loginNav, animated: true, completion: nil)
//        }
//        alert.addAction(loginAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
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
    
    // Add left menu button to navigation controller
    //    func addLeftSideMenuButton() {
    //        self.addLeftMenuButton()
    //        self.enableSlidePanGestureForLeftMenu()
    //    }
    
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
    
    
//    func performFavorite(venueId: Int, isFavorite: Bool, complition: (_ result: Bool) -> Void) {
//        var params = [String: AnyObject]()
//        params["venue_id"] = venueId
//        params["fav"] = isFavorite
//        VSWebRequest.POST(ApiUrls.addFavorite, authType: .Bearer, params: params, complition: { (result) -> Void in
//            if let responseResult = result {
//                let jsonResult = JSON(responseResult)
//                if jsonResult["Status"].string == "Success" {
//                    complition(result: true)
//                } else {
//                    complition(result: false)
//                }
//                print("Response Result: \(responseResult)")
//            }
//        }) { (error) -> Void in
//            complition(result: false)
//            var errorCode = 0
//            if let err = error {
//                errorCode = err.code
//            }
//            self.showAlert(message: AlertMessages.getMessage(at: errorCode))
//        }
//    }
}
