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
    
    static let clientId = "99645863475673498"
    
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
        static let globalInfo: String = "vs_global_info"
        static let loginCredentials: String = "vs_login_credentials"
        static let loginType: String = "vs_user_login_type"
        static let locationInfo: String = "vs_user_location"
        static let maxCountryId: String = "vs_max_country_id"
        static let maxStateId: String = "vs_max_state_id"
        static let maxCityId: String = "vs_max_city_id"
    }
    
    struct TableViewCellIdentifiers {
        static let loginTableCellIdentifier: String = "login_table_cell_Identifier"
        static let slideMenuCellIdentifier: String = "slide_menu_cell_identifier"
        static let homeTableSectionCellIdentifier: String = "home_table_section_cell_identifier"
        static let homeTableRowCellIdentifier: String = "home_table_row_cell_identifier"
        static let filterTableCellIdentifier: String = "filter_table_view_cell_identifier"
        static let filterTwoTextTableCellIdentifier: String = "filter_two_text_table_cell_identifier"
        static let filterRadioTableCellIdentifier: String = "filter_radio_table_cell_identifier"
    }
    
    // MARK: - Storyboard Segue Identifiers
    struct SegueIdentifiers {
        static let loginToHomeSegue: String = "login_to_home_segue"
        static let filterViewSegue: String = "home_to_filter_view_segue"
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
    
}
