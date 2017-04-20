//
//  Constants.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  // App defaults
  static let appStoreId: String = "1094602630"
  static let clientId = "334a059d82304f4e9892ee5932f81425"
  static let deviceId = UIDevice.current.identifierForVendor!.uuidString
  static let OSVersion = UIDevice.current.systemVersion
  
  // Get device type
  static let idimo =  UI_USER_INTERFACE_IDIOM()
  static let ipad  = UIUserInterfaceIdiom.pad
  static let iphone =  UIUserInterfaceIdiom.phone
  static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
  static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
  
  // Alert View Title
  static let alertTitle: String = "DMS"
  
  // App Flags
  static let allowedUnauthorizedSSL: Bool = false
  static let allowedAutoUpdateCheck: Bool = false
  
  // Debugging Flags
  static let allowedWSLog: Bool = true
  static let allowClassLog: Bool = true
  
  // Dummy Flags
  static let enableDummyJsonResponse: Bool = false
  
  // Default Flags
  static let enableDefaultLogin: Bool = true
  
  // MARK: - NSUserDefault keys
  struct UserDefault {
    static let authAccessToken: String = "dms_bearer_token"
    static let authRefereshToken: String = "dms_referesh_token"
    static let userLoggedToken: String = "dms_user_logged_in"
    static let gender: String = "gender"
  }
  
  struct FilterExpand {
    static let TRUE = "true"
    static let FALSE = "false"
  }
  
  struct TableViewCellIdentifiers {
    static let loginTableCellIdentifier: String = "login_table_cell_Identifier"
    static let slideMenuCellIdentifier: String = "slide_menu_cell_identifier"
    static let homeTableSectionCellIdentifier: String = "home_table_section_cell_identifier"
    static let homeTableRowCellIdentifier: String = "home_table_row_cell_identifier"
    static let filterTableCellIdentifier: String = "filter_table_view_cell_identifier"
    static let filterTwoTextTableCellIdentifier: String = "filter_two_text_table_cell_identifier"
    static let filterRadioTableCellIdentifier: String = "filter_radio_table_cell_identifier"
    
    static let filterExpandTableCellIdentifier: String = "filter_expand_table_cell"
  }
  
  struct Nib {
    static let optionsHeaderIdentifier = "PdfComparisonHeaderIdentifier"
    static let optionsFooterIdentifier = "PdfComparisonFooterIdentifier"
  }
  
  // MARK: - Storyboard Segue Identifiers
  struct SegueIdentifiers {
    static let loginToHomeSegue: String = "login_to_home_segue"
    static let filterViewSegue: String = "home_to_filter_view_segue"
    static let comparisonOptionsIdentifier: String = "comparisonOptionsSegue"
  }
  
  struct Font {
    static let proximaRegular = UIFont(name: "ProximaNovaA-Regular", size: 14)
    static let proximaBold = UIFont(name: "ProximaNova-Bold", size: 14)
  }
  
  struct SocialKey {
    static let googlePlusApiKey = "AIzaSyA8s3L2Uqku8LsCGDKi-jOTgH2L-TUxgFY"
    static let googlePlusClientId = "691048376264-d1mbir3eo07ltmjosci03c0k940hrbtq.apps.googleusercontent.com"
    static let googleMapApiKey = "AIzaSyDzXmmiV5YDwn-cYPcpti9_kIpiHiMUtik"
  }
  
  struct DMSLoginType {
    static let facebookLoginKey = "vs_facebook_key"
    static let googleLoginKey = "vs_google_key"
    static let manuallyLoginKey = "vs_manually_key"
  }
  
  // MARK: - Api URLs
  struct ApiUrls {
    // Test Server Urls
    static var baseUrl: String = "http://192.168.0.25:81/" {
      didSet {
        apiBaseUrl = baseUrl + "api/"
        // WS Urls
        //Login
        login = apiBaseUrl + "userLogin"
        //Home Data & Filter
        filter = apiBaseUrl + "result/ShowSearchResults"
        //Documnet List for Filter
        getDocument = apiBaseUrl + "documenttype"
        //Pdf Archived
        archived = apiBaseUrl + "getArchived"
        //Pdf Show File
        showFile = apiBaseUrl + "showfile"
      }
    }
    static var apiBaseUrl: String = baseUrl + "api/"
    // WS Urls
    //Login
    static var login: String = apiBaseUrl + "userLogin"
    //Home Data & Filter
    static var filter: String = apiBaseUrl + "result/ShowSearchResults"
    //Documnet List for Filter
    static var getDocument: String = apiBaseUrl + "documenttype"
    //Pdf Archived
    static var archived: String = apiBaseUrl + "getArchived"
    //Pdf Show File
    static var showFile: String = apiBaseUrl + "showfile"
    static var access_token: String = apiBaseUrl + "userLogin"
  }
}
