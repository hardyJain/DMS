//
//  AppDelegate.swift
//  DMS
//
//  Created by Scorg Technologies on 16/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum Menus: String {
    case homeController = "homeController"
    case aboutController = "aboutViewController"
    case logoutController = "logout"
}

enum Controllers: String {
    case menuController = "menuController"
    case pdfCompareDrawer = "pdfCompareOptionsViewController"
    case loginController = "loginViewController"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.initApplicationTheme()
    let reach = Reach()
    reach.monitorReachabilityChanges()
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
  func initApplicationTheme() {
    let navigationBarAppearace = UINavigationBar.appearance()
    navigationBarAppearace.tintColor = UIColor.white
    navigationBarAppearace.barTintColor = UIColor(red: 89/255, green: 177/255, blue: 213/255, alpha: 1)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    
  }
  
  func initLoginScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginController = storyboard.instantiateViewController(withIdentifier: Controllers.loginController.rawValue)
    self.window?.rootViewController = loginController
    self.window?.makeKeyAndVisible()
  }
  
  func initDrawerView() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //Controller instantiate using storyboard
    let leftSideDrawerViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: Controllers.menuController.rawValue)
    let centerViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: Menus.homeController.rawValue)
    let rightSideDrawerViewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: Controllers.pdfCompareDrawer.rawValue)
    
    //Set navigation controller to every UIController
    let centerNavigationController: UINavigationController = UINavigationController(rootViewController: centerViewController!)
    let rightSideNavController: UINavigationController =
      UINavigationController(rootViewController: rightSideDrawerViewController!)
    let leftSideNavController: UINavigationController = UINavigationController(rootViewController: leftSideDrawerViewController!)
    
    //Initiate drawer controller
    let slideMenuController = SlideMenuController(mainViewController: centerNavigationController, leftMenuViewController: leftSideNavController, rightMenuViewController: rightSideNavController)
    
    slideMenuController.removeRightGestures()
    slideMenuController.changeLeftViewWidth(Constants.screenWidth / 1.5)
    slideMenuController.changeRightViewWidth(Constants.screenWidth / 1.5)
    
    //Set MMDDrawerController to window
    self.window?.rootViewController = slideMenuController
    self.window?.makeKeyAndVisible()
  }
}

