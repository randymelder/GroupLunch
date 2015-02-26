//
//  ViewController.swift
//  grouplunch
//
//  Created by Randy Melder on 1/30/15.
//  Copyright (c) 2015 RCM Software, LLC. All rights reserved.
//

import UIKit
import iAd
import MessageUI

class GroupLunchViewController: UIViewController, UITextFieldDelegate, ADBannerViewDelegate, MFMailComposeViewControllerDelegate  {
    
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
    var EMAIL_SUPPORT_SUBJ          = "Our Lunch bill by GroupLunch™ iOS App" as String
    
    var amtTipTotal:Double      = 0.0
    var amtJustTipEach:Double   = 0.0
    var amtPreTipEach:Double    = 0.0
    var amtWithTipEach:Double   = 0.0
    var amtTotalBill:Double     = 0.0
    
    
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
    
    
    
    
    // MARK: ------------- Email -----------------
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC  = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setSubject("\(self.EMAIL_SUPPORT_SUBJ)")
        mailComposerVC.setMessageBody(self.getEmailHTML(), isHTML: true)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.app.printLogMessage("Device cannot send email")
        let sendMailErrorAlert = UIAlertView(title: "No Email??", message: "Your device appears to not have an email account configured. Please add an account.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if (nil != error) {
            self.app.printLogMessage(error.description)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: --------------- UI Actions --------------
    @IBAction func doEmailButton(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
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
        
        self.amtTipTotal      = self.bill_amount * (Double(self.pct_tip) / 100);
        self.amtJustTipEach   = amtTipTotal / Double(self.qty_payers)
        self.amtPreTipEach    = self.bill_amount / Double(self.qty_payers)
        self.amtWithTipEach   = amtJustTipEach + amtPreTipEach
        self.amtTotalBill     = amtTipTotal + self.bill_amount
        
        self.labelAmountTipTotal.text       = NSString(format: "%.2lf", self.amtTipTotal)
        self.labelAmountPreTipEach.text     = NSString(format: "%.2lf", self.amtPreTipEach)
        self.labelAmountWithTipEach.text    = NSString(format: "%.2lf", self.amtWithTipEach)
        self.labelAmountTotalBill.text      = NSString(format: "%.2lf", self.amtTotalBill)
        
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
    
    func getEmailHTML() -> String {
        let html = " <p><img alt=\"\" src=\"http://cdn.spininternetmedia.com/spininternetmedia.com/grouplunchapp/logo_20150214.png\" style=\"border-width: 0px; border-style: solid; margin: 2px; width: 200px; height: 39px;\"/></p><p>Lunch Bill Breakdown</p><table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" style=\"width: 350px;\"><tbody><tr><td style=\"text-align: right;\" width=\"50%\">Amount on Bill:</td><td width=\"50%\">$[[AMOUNT_ON_BILL]]</td></tr><tr><td style=\"text-align: right;\">Qty of Payers:&nbsp;</td><td>[[QTY_PAYERS]]</td></tr><tr><td style=\"text-align: right;\">Tip %:&nbsp;</td><td>[[TIP_PCT]]</td></tr><tr><td style=\"text-align: right;\">Tip Total:</td><td>$[[TIP_TOTAL]]</td></tr><tr><td style=\"text-align: right;\">Pre Tip Each:</td><td>$[[PRE_TIP_EACH]]</td></tr><tr><td style=\"text-align: right;\">With Tip Each:</td><td>$[[WITH_TIP_EACH]]</td></tr><tr><td style=\"text-align: right;\">Total Bill:&nbsp;</td><td>$[[TOTAL_BILL]]</td></tr></tbody></table><h2>Group Lunch&trade; for iOS</h2><p><a href=\"itmss://itunes.apple.com/us/app/group-lunch/id406438527\" target=\"_blank\"><img alt=\"Download Group Lunch at the App Store\" border=\"0\" src=\"http://spininternetmedia.com/wp-content/uploads/2013/11/Download_on_the_App_Store_Badge_US-UK_135x40.png\" style=\"margin: 2px; width: 135px; height: 40px; border:0;\"/></a></p><p>&quot;Group Lunch&quot; is a trademark of RCM Software, LLC</p>"
        
        let html1 = html.stringByReplacingOccurrencesOfString("[[AMOUNT_ON_BILL]]", withString: self.textFieldAmountOnBill.text, options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html2 = html1.stringByReplacingOccurrencesOfString("[[QTY_PAYERS]]", withString: String(self.qty_payers), options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html3 = html2.stringByReplacingOccurrencesOfString("[[TIP_PCT]]", withString: String(self.pct_tip), options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html4 = html3.stringByReplacingOccurrencesOfString("[[TIP_TOTAL]]", withString: String(format:"%.2f", self.amtTipTotal), options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html5 = html4.stringByReplacingOccurrencesOfString("[[PRE_TIP_EACH]]", withString: String(format:"%.2f", self.amtPreTipEach), options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html6 = html5.stringByReplacingOccurrencesOfString("[[WITH_TIP_EACH]]", withString: String(format:"%.2f", self.amtWithTipEach), options: NSStringCompareOptions.LiteralSearch, range: nil)
        let html7 = html6.stringByReplacingOccurrencesOfString("[[TOTAL_BILL]]", withString: String(format:"%.2f", self.amtTotalBill), options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return html7
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

