//
//  PdfComparisonViewController.swift
//  DMS
//
//  Created by Swapnil Dhotre on 16/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSPdfAlertViewController: UIViewController {
  
  //IBOultet
  @IBOutlet weak var pdf2Image: UIImageView!
  @IBOutlet weak var pdf1Image: UIImageView!
  @IBOutlet weak var labelFirstFileName: UILabel!
  @IBOutlet weak var labelSecondFileName: UILabel!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var btnComparePdfTitle: UIButton!
  @IBOutlet weak var btnCompare: UIButton!
  @IBOutlet weak var compareBackgroundView: UIView!
  @IBOutlet weak var pdfImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var labelPdfWidthConstraint: NSLayoutConstraint!
  //Variables
  var pdf1Name: String = ""
  var pdf2Name: String = ""
  var comparePdf: (() -> Void)?
  
  //MARK: - UIView Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showPdfDetails(withTitle: self.pdf1Name, anotherFile: self.pdf2Name)
    self.setUIAppearance()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    self.setButtonAppearance()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if touches.first?.view == self.view {
      print("hey you touched me")
      self.btnComparePdfTitle.sendActions(for: .touchUpInside)
    }
  }
  
  //MARK: - Action Methods
  @IBAction func comparePdfTitleTapped(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
  }
  
  @IBAction func cancelBtnTapped(_ sender: UIButton) {
    self.dismiss(animated: false, completion: nil)
  }
  
  @IBAction func comparePdf(_ sender: UIButton) {
    self.comparePdf?()
    self.dismiss(animated: false, completion: nil)
  }
  
  //MARK: - Custom Methods
  func showPdfDetails(withTitle title1: String, anotherFile title2: String) {
    self.labelFirstFileName.text = title1
    self.labelSecondFileName.text = title2
    if title2 == "" {
      self.pdfImageWidthConstraint.isActive = false
      self.labelPdfWidthConstraint.isActive = false
    }
  }
  
  func setButtonAppearance() {
    let corners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.btnComparePdfTitle.layer.bounds.width, height: self.btnComparePdfTitle.layer.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: 12, height: 12))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.btnComparePdfTitle.layer.masksToBounds = true
    self.btnComparePdfTitle.layer.mask = mask
  }
  
  func setUIAppearance() {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    self.compareBackgroundView.backgroundColor = #colorLiteral(red: 0.7222919365, green: 0.7222919365, blue: 0.7222919365, alpha: 1)
    self.compareBackgroundView.layer.cornerRadius = 2
    self.compareBackgroundView.layer.shadowColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    self.compareBackgroundView.layer.shadowOpacity = 1
    self.compareBackgroundView.layer.shadowOffset  = CGSize(width: 2, height: -2)
    self.compareBackgroundView.layer.shadowRadius  = 2
    if self.pdf2Name == "" {
      self.pdf2Image.image = UIImage(named: "pdfUnselected")
      self.btnCompare.isEnabled = false
      self.btnCompare.backgroundColor = UIColor.lightGray
    } else {
      self.pdf2Image.image = UIImage(named: "pdfSelected")
      self.btnCompare.isEnabled = true
      self.btnCompare.backgroundColor = UIColor(hexString: "59B1D5")
    }
    
  }
}
