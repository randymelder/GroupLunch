//
//  ViewController.swift
//  grouplunch
//
//  Created by Randy Melder on 1/30/15.
//  Copyright (c) 2015 RCM Software, LLC. All rights reserved.
//

import UIKit
import iAd

class GroupLunchViewController: UIViewController, UITextFieldDelegate, ADBannerViewDelegate {
    
    let DEFAULT_LABEL_AMT           = "0.00"
    let DEFAULT_LABEL_PAYERS        = "Qty of Payers"
    let DEFAULT_LABEL_TIP           = "Tip"
    let DEFAULT_TIP_PCT             = 15.0
    let MINIMUM_PAYERS              = 1
    let MINIMUM_TIP_PCT             = 0
    let MINIMUM_BILL_AMT            = 0.0
    let TEXTFIELD_TAG_BILL_AMT      = 111
    let DEBUG_ON                    = false
    let SEGUE_ID_SUPPORT            = "supportSegue"
    let TAG_IMAGE_LOGO              = 444
    
    var qty_payers:Int              = 1
    var pct_tip:Int                 = 0
    var bill_amount:Double          = 0.0
    var app:AppDelegate             = UIApplication.sharedApplication().delegate as AppDelegate
    
    // --------------- UI Outlets -------------- //
    @IBOutlet weak var stepperPayers: UIStepper!
    
    @IBOutlet weak var stepperTip: UIStepper!
    
    @IBOutlet weak var labelQtyPayers: UILabel!
    
    @IBOutlet weak var labelTipPct: UILabel!
    
    @IBOutlet weak var labelAmountTipTotal: UILabel!
    
    @IBOutlet weak var labelAmountPreTipEach: UILabel!
    
    @IBOutlet weak var labelAmountWithTipEach: UILabel!
    
    @IBOutlet weak var labelAmountTotalBill: UILabel!

    @IBOutlet weak var textFieldAmountOnBill: UITextField!
    
    @IBOutlet weak var appversionLabel: UILabel!
    
    @IBOutlet weak var adBanner: ADBannerView!
    
    // MARK: --------------- UI Actions --------------
    @IBAction func doAmountChange(sender: UITextField) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
    }
    @IBAction func doQtyPayers(sender: UIStepper) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        var value:Int = Int(sender.value)
        self.view.endEditing(true)
        
        if (value > self.MINIMUM_PAYERS) {
            self.qty_payers = value
        } else {
            self.qty_payers = MINIMUM_PAYERS
            sender.value    = Double(MINIMUM_PAYERS)
        }
        
        self.labelQtyPayers.text = NSString(format: "%@ %d:", self.DEFAULT_LABEL_PAYERS, self.qty_payers)
        
        doCalculateAmounts()
    }
    
    @IBAction func doTipChange(sender: UIStepper) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        var value:Int = Int(sender.value)
        self.view.endEditing(true)
        
        if (value > self.MINIMUM_TIP_PCT) {
            self.pct_tip    = value
        } else {
            self.pct_tip    = MINIMUM_TIP_PCT
            sender.value    = Double(MINIMUM_TIP_PCT)
        }
        
        self.labelTipPct.text = NSString(format: "%@ %d%%", self.DEFAULT_LABEL_TIP, self.pct_tip)
        
        doCalculateAmounts()
    }
    
    func doCalculateAmounts() {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        
        var amtTipTotal:Double      = self.bill_amount * (Double(self.pct_tip) / 100);
        var amtJustTipEach:Double   = amtTipTotal / Double(self.qty_payers)
        var amtPreTipEach:Double    = self.bill_amount / Double(self.qty_payers)
        var amtWithTipEach:Double   = amtJustTipEach + amtPreTipEach
        var amtTotalBill:Double     = amtTipTotal + self.bill_amount
        
        self.labelAmountTipTotal.text   = NSString(format: "%.2lf", amtTipTotal)
        self.labelAmountPreTipEach.text = NSString(format: "%.2lf", amtPreTipEach)
        self.labelAmountWithTipEach.text = NSString(format: "%.2lf", amtWithTipEach)
        self.labelAmountTotalBill.text = NSString(format: "%.2lf", amtTotalBill)
        
    }
    
    // MARK: -------------- Initial UI SETUP
    func doSetInitialValues() {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        
        self.pct_tip                        = Int(DEFAULT_TIP_PCT)
        
        self.labelAmountTipTotal.text       = self.DEFAULT_LABEL_AMT
        self.labelAmountPreTipEach.text     = self.DEFAULT_LABEL_AMT
        self.labelAmountWithTipEach.text    = self.DEFAULT_LABEL_AMT
        self.labelAmountTotalBill.text      = self.DEFAULT_LABEL_AMT
        self.textFieldAmountOnBill.text     = self.DEFAULT_LABEL_AMT
        
        self.labelQtyPayers.text            = NSString(format: "%@ %d:", self.DEFAULT_LABEL_PAYERS, self.qty_payers)
        self.labelTipPct.text               = NSString(format: "%@ %d%%", self.DEFAULT_LABEL_TIP, self.pct_tip)
        
        self.stepperPayers.value            = 1
        self.stepperTip.value               = DEFAULT_TIP_PCT
    }

    // MARK: --------------- Delegates ----------------
    func textFieldDidBeginEditing(textField: UITextField) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        if (self.TEXTFIELD_TAG_BILL_AMT == textField.tag) {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        var amount:Double = self.MINIMUM_BILL_AMT
        
        if (self.TEXTFIELD_TAG_BILL_AMT == textField.tag) {
            amount          = (textField.text as NSString).doubleValue
        }
        
        self.bill_amount    = amount
        textField.text      = NSString(format: "%1.2lf", amount)
        
        doCalculateAmounts()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        self.adBanner.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        println("Ad failed with error: %s", error.description)
        self.adBanner.hidden = true
    }
    
    // MARK: --------------- Built Ins ----------------
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        
        var touch: UITouch = touches.anyObject() as UITouch
        
        if (touch.view.isKindOfClass(UIImageView)) {
            let touchedView: UIImageView = touch.view as UIImageView
            if (self.TAG_IMAGE_LOGO == touchedView.tag) {
                performSegueWithIdentifier(SEGUE_ID_SUPPORT, sender: self)
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // AppDelegate
        self.app                    = UIApplication.sharedApplication().delegate as AppDelegate
        
        // Set start amounts
        doSetInitialValues()
        
        self.textFieldAmountOnBill.delegate         = self
        self.textFieldAmountOnBill.keyboardType     = UIKeyboardType.DecimalPad
        
        // Version
        let appversion              = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as NSString) as String
        self.appversionLabel.text   = appversion
        
        // Banner
        self.canDisplayBannerAds    = true
        self.adBanner.delegate      = self
        self.adBanner.hidden        = true
    }

    override func didReceiveMemoryWarning() {
        if (self.DEBUG_ON) { app.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: (__LINE__)) }
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

