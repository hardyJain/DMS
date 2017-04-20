//
//  DMSPdfComparisonViewController.swift
//  DMS
//
//  Created by Swapnil Dhotre on 14/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SlideMenuControllerSwift

class DMSPdfComparisonViewController: UIViewController, UIScrollViewDelegate {
  //IBOutlet
  @IBOutlet weak var separatorView: UIImageView!
  @IBOutlet weak var gapHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstPdfView: UIWebView!
  @IBOutlet weak var firstPdfLabel: UILabel!
  @IBOutlet weak var secondPdfView: UIWebView!
  @IBOutlet weak var secondPdfLabel: UILabel!
  @IBOutlet weak var firstFileVisualEffect: UIVisualEffectView!
  @IBOutlet weak var secondFileVisualEffect: UIVisualEffectView!
  @IBOutlet weak var paginationTableView: UITableView!
  //Variables
  var file1pageCount: Int = 0
  var file2pageCount: Int = 0
  var file1PageHeight: Double = 0
  var file2PageHeight: Double = 0
  var pdfArchivedRecords: [PdfFileArchivedDetails] = []
  var isSinglePdfSelected: Bool = false
  var checkIfBothFilesLoaded: Bool = false
  var isFirstPdfContentAvailable: Bool = true
  var isSecondPdfContentAvailable: Bool = true
  var start: Date?
  var end: Date?
    
  //MARK: - Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "PDF"
    start = Date()
    self.pdfArchivedRecords = Globals.sharedInstance.archivedData
    self.showPdfView()
    self.setDelegates()
    self.setUIAppearance()
    NotificationCenter.default.addObserver(self, selector: #selector(DMSPdfComparisonViewController.goToPage(notification:)), name: NSNotification.Name(rawValue: "TreeViewCellSelected"), object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if let btn = self.navigationController?.view.viewWithTag(1001) as? FilterButton {
      btn.isHidden = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - Action Methods
  @IBAction func menuBtnTapped(_ sender: UIBarButtonItem) {
    if let slideController = self.slideMenuController() {
      slideController.openRight()
      slideController.addRightGestures()
    }
  }
  
  //MARK: - Scroll delegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if Globals.sharedInstance.isPdfScrollable && self.isFirstPdfContentAvailable  && self.isSecondPdfContentAvailable {
      if scrollView.tag == 1 || scrollView.tag == 2 {
        self.secondPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
        self.firstPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
        self.secondPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
        self.firstPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
      }
    }
    else if Globals.sharedInstance.isPdfScrollable && !self.isFirstPdfContentAvailable {
      self.firstPdfView.isUserInteractionEnabled = false
    } else if Globals.sharedInstance.isPdfScrollable && !self.isSecondPdfContentAvailable {
      self.secondPdfView.isUserInteractionEnabled = false
    }
  }
  
  //MARK: - Zooming
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    self.secondPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
    self.firstPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
    self.secondPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
    self.firstPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    self.secondPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
    self.firstPdfView.scrollView.contentOffset.y = scrollView.contentOffset.y
    self.secondPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
    self.firstPdfView.scrollView.contentOffset.x = scrollView.contentOffset.x
    self.secondPdfView.scrollView.zoomScale = scale
    self.firstPdfView.scrollView.zoomScale = scale
  }
  
  //MARK: - Other Functional Methods
  //Api request.
  func getArchivedDataFromApi(of archivedObject: PdfFileArchivedDetails, fileName: String) {
    self.showProgress(status: "Loading...")
    let params = self.getDataDictionaryForArchived(archivedObject: archivedObject)
    DMSWebRequest.POST(url: Constants.ApiUrls.archived, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: params as [String : AnyObject]?, complition: {(result) -> Void in
      if let data = result {
        let json = JSON(data)
        var pageCount: Int = 0
        var docTypes: [Parameters] = []
        for (_, object) in json["data"]["archiveData"][0]["lstDocCategories"][0]["lstDocTypes"] {
          pageCount += object["pageCount"].int ?? 0
          let object: Parameters = ["typeId": object["typeId"].int ?? 0, "typeName": object["typeName"].string ?? "", "abbreviation": object["abbreviation"].string ?? "", "createdDate": object["createdDate"].string ?? "", "pageCount": object["pageCount"].int ?? 0, "pageNumber": object["pageNumber"].int ?? 0]
            docTypes.append(object)
        }
        self.getPdfFile(docTypes: docTypes, pageCount: pageCount, fileName: fileName)
      }
    }, failure: {(error) -> Void in
      if let err = error {
        self.hideProgress()
        self.showAlertMessageWithIndex(index: err.code)
      }
    })
  }
    
  //Save Base 64 data to .pdf with file name
  func saveBase64StringToPDF(withBase64 base64String: String, andFileName fileName: String) {
    guard
      var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
      let convertedData = Data(base64Encoded: base64String)
      else {
        //handle error when getting documents URL
        return
      }
      //name your file however you prefer
      documentsURL.appendPathComponent(fileName)
//    print("File Creation Start time: \(Date())")
      do {
        try convertedData.write(to: documentsURL)
      } catch let error {
      //handle write error here
        print("Error in file creation: \(error)")
      }
//        print("File Creation End time: \(Date())")
      if fileName == "file1.pdf" {
        self.firstPdfView.loadRequest(URLRequest(url: documentsURL))
      } else if fileName == "file2.pdf" {
        self.secondPdfView.loadRequest(URLRequest(url: documentsURL))
      }
  }
    
  func getDataDictionaryForFile(docTypes: [Parameters], fileIndex index: Int) -> Parameters {
    var param: Parameters = [:]
    if self.pdfArchivedRecords.count > 0 {
      param = ["patientId": self.pdfArchivedRecords[index].patientId, "fileType": self.pdfArchivedRecords[index].fileType, "fileTypeRefId": self.pdfArchivedRecords[index].referenceId, "lstDocTypes": docTypes]
    }
    return param
  }
    
  func getPdfFile(docTypes: [Parameters], pageCount: Int, fileName: String) {
    var params: Parameters = [:]
    if fileName == "file1.pdf" {
      self.file1pageCount = pageCount
      params = self.getDataDictionaryForFile(docTypes: docTypes, fileIndex: 0)
    } else {
      self.file2pageCount = pageCount
      params = self.getDataDictionaryForFile(docTypes: docTypes, fileIndex: 1)
    }
    self.showProgress(status: "Loading...")
    print("Initiating request for file: \(Date())")
    DMSWebRequest.POST(url: Constants.ApiUrls.showFile, authType: .bearer, requestFormat: .jsonFormat, headers: Globals.sharedInstance.getRequestHeaderParams(), params: params as [String : AnyObject]?, complition: { (response) in
      if let data = response {
        let json = JSON(data)
        if let base64 = json["data"]["fileData"].string {
          self.saveBase64StringToPDF(withBase64: base64, andFileName: fileName)
        }
      }
    }) { (error) in
        if let err = error {
          self.hideProgress()
          AlertMessages.showAlert(withTitle: "Alert", viewController: self, messageIndex: err.code, actionTitles: ["OK"], actions: [{(action) in
          }])
      }
    }
  }
  
  //MARK: - Custom Methods
  func setUIAppearance() {
    //Separator image view
    self.separatorView.image = UIImage(named: "repeater")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    self.firstPdfView.layer.borderWidth = 1
    self.firstPdfView.layer.borderColor = UIColor.darkGray.cgColor
    self.firstFileVisualEffect.isHidden = true
    self.secondPdfView.layer.borderWidth = 1
    self.secondPdfView.layer.borderColor = UIColor.darkGray.cgColor
    self.secondFileVisualEffect.isHidden = true
  }
    
  func goToPage(notification: Notification) {
    self.firstFileVisualEffect.isHidden = true
    self.secondFileVisualEffect.isHidden = true
    if let data = notification.object {
      let json = JSON(data)
      if let pageNumber = json["docTypeObject"]["otherFilePageNumber1"].int, pageNumber != -1 {
        //File on which first tapped
        let y: CGFloat = CGFloat((Double(pageNumber) * self.file1PageHeight))
                self.firstPdfView.scrollView.contentOffset.y = y
      } else {
        let pageNumberForFile1 = json["docTypeObject"]["pageNumberForFile1"].int ?? -1
        if pageNumberForFile1 != -1 {
          //File on which first tapped
          let y: CGFloat = CGFloat((Double(pageNumberForFile1) * self.file1PageHeight))
          self.firstPdfView.scrollView.contentOffset.y = y
        } else {
          self.firstFileVisualEffect.isHidden = false
        }
      }
      if let pageNumber = json["docTypeObject"]["otherFilePageNumber2"].int, pageNumber != -1 {
        //File on which Second tapped
        let y: CGFloat = CGFloat((Double(pageNumber) * self.file2PageHeight))
                self.secondPdfView.scrollView.contentOffset.y = y
      } else {
        let pageNumberForFile2 = json["docTypeObject"]["pageNumberForFile2"].int ?? -1
        //After confirm Identified that file has found then navigate to that page in another file
        if pageNumberForFile2 != -1 {
          let y2: CGFloat = CGFloat((Double(pageNumberForFile2) * self.file2PageHeight))
          self.secondPdfView.scrollView.contentOffset.y = y2
        } else {
          self.secondFileVisualEffect.isHidden = false
        }
      }
    }
  }
    
  func setDelegates() {
    self.firstPdfView.scalesPageToFit = true
    self.secondPdfView.scalesPageToFit = true
    self.firstPdfView.delegate = self
    self.secondPdfView.delegate = self
    self.firstPdfView.scrollView.delegate = self
    self.secondPdfView.scrollView.delegate = self
    self.firstPdfView.scrollView.tag = 1
    self.secondPdfView.scrollView.tag = 2
  }
    
  func getDataDictionaryForArchived(archivedObject: PdfFileArchivedDetails) -> Parameters {
    let param: Parameters = ["lstSearchParam":[["patientId": archivedObject.patientId, "fileType": archivedObject.fileType, "fileTypeRefId": archivedObject.referenceId]]]
    return param
  }
    
  func showPdfView() {
    self.checkIfBothFilesLoaded = false
    self.showProgress(status: "Loading...")
    if self.isSinglePdfSelected {
      self.gapHeightConstraint.constant = 0
      self.secondHeightConstraint.isActive = false
      self.firstPdfLabel.text = "\(self.pdfArchivedRecords[0].fileType)-\(self.pdfArchivedRecords[0].referenceId)"
      DispatchQueue.global(qos: .userInteractive).async {
      self.getArchivedDataFromApi(of: self.pdfArchivedRecords[0], fileName: "file1.pdf")
      DispatchQueue.main.async { }
      }
    } else {
        self.gapHeightConstraint.constant = 20
        self.secondHeightConstraint.isActive = true
        self.firstPdfLabel.text = "\(self.pdfArchivedRecords[0].fileType)-\(self.pdfArchivedRecords[0].referenceId)"
        self.secondPdfLabel.text = "\(self.pdfArchivedRecords[1].fileType)-\(self.pdfArchivedRecords[1].referenceId)"
        DispatchQueue.global(qos: .userInteractive).async {
        self.getArchivedDataFromApi(of: self.pdfArchivedRecords[0], fileName: "file1.pdf")
        self.getArchivedDataFromApi(of: self.pdfArchivedRecords[1], fileName: "file2.pdf")
        DispatchQueue.main.async { }
      }
    }
  }
}

//MARK: - Extensions
//MARK: - UITableview Datasource Method
extension DMSPdfComparisonViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.file1pageCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: DMSPaginationViewCell = self.paginationTableView.dequeueReusableCell(withIdentifier: "pageView") as! DMSPaginationViewCell
    cell.labelPageNumber.text = "\(indexPath.row + 1)"
    return cell
  }
}

//MARK: - UIWebview delegate method
extension DMSPdfComparisonViewController: UIWebViewDelegate {
  //MARK: - Web view delegate
  func webViewDidFinishLoad(_ webView: UIWebView) {
    if self.isSinglePdfSelected {
      self.hideProgress()
    } else {
      //Here when first file is loaded it will enter in this condition but will set boolean when for another file loaded this condition will be found set then hide progress
      if self.checkIfBothFilesLoaded {
        self.hideProgress()
      }
      self.checkIfBothFilesLoaded = true
    }
    if self.firstPdfView == webView {
      self.file1PageHeight = Double(webView.scrollView.contentSize.height) / Double(self.file1pageCount)
    } else {
      self.file2PageHeight = Double(webView.scrollView.contentSize.height) / Double(self.file2pageCount)
    }
    end = Date()
  }
}
